local function default_mode_settings(mappings)
	local is_missing = false
	local is_having = false
	for _, mapping in ipairs(mappings) do
		if not mapping.mode then
			mapping.mode = "n" -- default to normal mode if not specified
			is_missing = true
		else
			is_having = true
		end
	end
	if is_missing and is_having then
		vim.notify("Some mappings are missing 'mode' field. Defaulting to 'n' (normal mode).", vim.log.levels.WARN)
	end
end

-- flag to indicate whether we are in submode
local current_submode = nil

-- save the original mapping
local function save_mapping(mode, key, saved_mappings)
	local old = vim.fn.maparg(key, mode, false, true)
	saved_mappings[key] = old
end

-- restore the original mapping
local function restore_mapping(mode, key, saved_mappings)
	local saved = saved_mappings[key]

	-- delete the mapping if there was no original mapping
	if not saved or vim.tbl_isempty(saved) then
		pcall(vim.api.nvim_del_keymap, mode, key)
		return
	end

	local opt = {
		desc = saved.desc,
		silent = saved.silent == 1,
		expr = saved.expr == 1,
		nowait = saved.nowait == 1,
		remap = not saved.noremap,
		buffer = saved.buffer,
		callback = saved.callback,
	}

	if opt.buffer == nil or opt.buffer == 0 then
		opt.buffer = nil
	end

	if saved.callback then
		vim.keymap.set(mode, key, saved.callback, opt)
	elseif saved.rhs then
		vim.keymap.set(mode, key, saved.rhs, opt)
	else
		-- can't find a valid mapping to restore, so delete and raise a warning
		-- should not happen, but just in case
		pcall(vim.api.nvim_del_keymap, mode, key)
		pcall(vim.notify, "Failed to restore mapping for key: " .. key, vim.log.levels.WARN)
	end
end

-- exit submode and restore original mappings
local function exit_submode(submode, mappings, saved_mappings)
	current_submode = nil
	vim.notify("👋 " .. submode .. " submode OFF", vim.log.levels.INFO)

	-- restore original mappings
	for _, mapping in ipairs(mappings) do
		restore_mapping(mapping.mode, mapping.key, saved_mappings)
	end
	restore_mapping("n", "<Esc>", saved_mappings)

	-- clear saved mappings in case of re-entering the submode
	for key in pairs(saved_mappings) do
		saved_mappings[key] = nil
	end
end

-- enter submode and set new mappings
local function enter_submode(submode, mappings)
	vim.notify("🗝️ " .. submode .. " submode ON", vim.log.levels.INFO)

	local saved_mappings = {}
	for _, mapping in ipairs(mappings) do
		-- save original mappings before setting new ones
		save_mapping(mapping.mode, mapping.key, saved_mappings)
		-- set new mappings for the submode
		vim.keymap.set(mapping.mode, mapping.key, mapping.rhs, { desc = mapping.desc })
	end

	-- Esc exits the submode
	-- this implementation could be hijacked by other plugins or mappings
	save_mapping("n", "<Esc>", saved_mappings) -- save original mapping for <Esc> to exit the submode
	vim.keymap.set("n", "<Esc>", function()
		exit_submode(submode, mappings, saved_mappings)
	end, { desc = "Exit " .. submode .. " submode" })
	-- this implementation can avoid being hijacked by other plugins or mappings, but it may cause issues with other plugins that use on_key
	-- vim.on_key(function(key)
	-- 	if current_submode == submode then
	-- 		if key == vim.keycode("<Esc>") then
	-- 			exit_submode(submode, mappings, saved_mappings)
	-- 		end
	-- 	end
	-- end)
end

local M = {}

function M.toggle_submode(submode, enter_key, mappings)
	vim.keymap.set("n", enter_key, function()
		if current_submode then
			vim.notify(
				"🙅 " .. current_submode .. " submode is already active. Press <Esc> to exit.",
				vim.log.levels.INFO
			)
		else
			current_submode = submode
			enter_submode(submode, mappings)
		end
	end, { desc = "Toggle " .. submode .. " submode" })
end

function M.setup(config)
	config = config or {}
	local submodes = config.submodes or {}

	for name, opts in pairs(submodes) do
		default_mode_settings(opts.mappings)
		M.toggle_submode(name, opts.enter_key, opts.mappings)
	end
end

return M
