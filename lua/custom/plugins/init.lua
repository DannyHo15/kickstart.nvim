-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local function gh(repo)
  if repo:match '^https?://' then return repo end
  return 'https://github.com/' .. repo
end

local pack_specs = {}
local pack_names = {}
local pack_load_names = {}
local inits = {}
local configs = {}
local builds = {}

if vim.pack and vim.pack.get then
  for _, plugin in ipairs(vim.pack.get()) do
    if plugin.spec and plugin.spec.name then pack_names[plugin.spec.name] = true end
  end
end

local function plugin_name(repo)
  local name = repo:gsub('%.git$', ''):match '([^/]+)$'
  return name
end

local function module_name(repo)
  local name = plugin_name(repo)
  return (name:gsub('%.nvim$', ''))
end

local function add_pack_spec(spec)
  local repo = type(spec) == 'table' and spec[1] or spec
  if type(repo) ~= 'string' or not repo:find('/') then return end

  local name = type(spec) == 'table' and spec.name or nil
  name = name or plugin_name(repo)
  table.insert(pack_load_names, name)
  if pack_names[name] then return end
  pack_names[name] = true

  local pack_spec = { src = gh(repo), name = name }
  if type(spec) == 'table' then
    if spec.branch then
      pack_spec.version = spec.branch
    elseif spec.version and spec.version ~= '*' and spec.version ~= false then
      if type(spec.version) == 'string' and spec.version:find('%*') then
        local ok, version_range = pcall(vim.version.range, spec.version)
        if ok then pack_spec.version = version_range end
      else
        pack_spec.version = spec.version
      end
    end
  end

  table.insert(pack_specs, pack_spec)
end

local function add_build(spec)
  if spec.build == nil then return end
  local repo = spec[1]
  local name = spec.name or plugin_name(repo)
  builds[name] = spec.build
end

local function run_build(name, build, path)
  if type(build) == 'function' then
    build()
    return
  end

  if type(build) == 'string' then
    local result = vim.system(vim.split(build, ' ', { trimempty = true }), { cwd = path }):wait()
    if result.code ~= 0 then
      local output = result.stderr ~= '' and result.stderr or result.stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end
end

local function set_keymap(key)
  if type(key) ~= 'table' or not key[1] or not key[2] then return end

  local opts = vim.tbl_extend('force', {}, key)
  local lhs = opts[1]
  local rhs = opts[2]
  opts[1] = nil
  opts[2] = nil

  local mode = opts.mode or 'n'
  local ft = opts.ft
  opts.mode = nil
  opts.ft = nil

  if ft then
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('custom-plugin-filetype-keys', { clear = false }),
      pattern = ft,
      callback = function(event)
        local buffer_opts = vim.tbl_extend('force', opts, { buffer = event.buf })
        vim.keymap.set(mode, lhs, rhs, buffer_opts)
      end,
    })
    return
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

local function collect_spec(spec)
  if type(spec) == 'string' then
    add_pack_spec(spec)
    return
  end

  if type(spec) ~= 'table' then return end

  if spec.enabled == false or spec.optional == true then return end
  if type(spec.cond) == 'function' and not spec.cond() then return end
  if spec.cond == false then return end

  -- A lazy.nvim-style plugin spec has the repository in the first array slot.
  -- A list of specs instead has tables in the array part.
  if type(spec[1]) == 'string' then
    local dependencies = spec.dependencies or spec.requires
    if type(dependencies) == 'string' then
      collect_spec(dependencies)
    elseif type(dependencies) == 'table' then
      for _, dependency in ipairs(dependencies) do
        collect_spec(dependency)
      end
    end

    add_pack_spec(spec)
    add_build(spec)

    if type(spec.init) == 'function' then
      table.insert(inits, spec.init)
    end

    if type(spec.keys) == 'table' then
      table.insert(configs, function()
        for _, key in ipairs(spec.keys) do
          set_keymap(key)
        end
      end)
    end

    if type(spec.config) == 'function' then
      table.insert(configs, function()
        if spec.opts ~= nil then
          spec.config(spec, vim.deepcopy(spec.opts))
        else
          spec.config()
        end
      end)
    elseif spec.opts ~= nil then
      local module = spec.main or module_name(spec[1])
      table.insert(configs, function()
        require(module).setup(vim.deepcopy(spec.opts))
      end)
    end
    return
  end

  for _, child in ipairs(spec) do
    collect_spec(child)
  end
end

-- Iterate over all Lua files in the plugins directory and load lazy.nvim-style specs.
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    local ok, spec = pcall(require, 'custom.plugins.' .. module)
    if ok then
      collect_spec(spec)
    else
      vim.notify(('Failed to load custom plugin spec %s: %s'):format(module, spec), vim.log.levels.ERROR)
    end
  end
end

for _, init in ipairs(inits) do
  local ok, err = pcall(init)
  if not ok then vim.notify(('Failed to initialize custom plugin: %s'):format(err), vim.log.levels.ERROR) end
end

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('custom-plugin-builds', { clear = true }),
  callback = function(event)
    local kind = event.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    local name = event.data.spec.name
    local build = builds[name]
    if build == nil then return end

    local ok, err = pcall(run_build, name, build, event.data.path)
    if not ok then vim.notify(('Build failed for %s:\n%s'):format(name, err), vim.log.levels.ERROR) end
  end,
})

if #pack_specs > 0 then vim.pack.add(pack_specs) end

for _, name in ipairs(pack_load_names) do
  pcall(vim.cmd.packadd, name)
end

for _, config in ipairs(configs) do
  local ok, err = pcall(config)
  if not ok then vim.notify(('Failed to configure custom plugin: %s'):format(err), vim.log.levels.ERROR) end
end
