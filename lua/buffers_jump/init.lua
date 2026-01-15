local API = {
	split = function(str, sep)
		local result = {}
		local pattern = "([^" .. sep .. "]+)"
		for part in string.gmatch(str, pattern) do
			table.insert(result, part)
		end
		return result
	end,
	str_trim = function(s)
		return s:match("^%s*(.-)%s*$")
	end,
	contains = function(s, w, strict)
		if strict == nil then
			strict = false
		end
		if strict == false then
			return string.find(s, w, 1, true) ~= nil
		else
			return string.find(s, "%f[%a]" .. w .. "%f[%A]") ~= nil
		end
	end
}

local M = {}
local fzf = nil
local fzf_props = {}

function Get_Buffers()
	local buffers = vim.api.nvim_list_bufs()
	local count = 0
	local names = {}
	local temp_names = {}
	local cb_name = vim.api.nvim_buf_get_name(0)
	for kb, vb in pairs(buffers) do
		local loaded = vim.api.nvim_buf_is_loaded(vb)
		local listed = vim.api.nvim_buf_get_option(vb, "buflisted")
		if loaded == true and listed == true then
			local name = vim.api.nvim_buf_get_name(vb)
			local name_split = API.split(name, "/")
			local file_name = name_split[#name_split - 1] .. "/" .. name_split[#name_split]
			if #name_split >= 3 then
				file_name = name_split[#name_split - 2] .. "/" .. name_split[#name_split - 1] .. "/" .. name_split[#name_split]
			end
			local full_item_name = file_name .. " | " .. name
			local trim = API.str_trim(full_item_name)
			if type(temp_names[API.str_trim(name)]) == "nil" then
				if trim ~= "" and
					API.str_trim(name) ~= API.str_trim(cb_name) and
					API.contains(trim, "term:") ~= true then
					table.insert(names, trim)
				end
			end
		end
	end
	return names
end

function Select_choice(choice)
	local split = API.split(choice, " | ")
	local path = split[#split]
	local command = "buffer " .. path
	local open, _ = pcall(vim.cmd, command)
	if open == true then
		vim.cmd(command)
	end
end

function Select()
	local buffers = Get_Buffers()

	if #buffers == 0 then
		vim.notify("I do not have non-empty buffers", vim.log.levels.INFO)
		return
	end
	if fzf ~= nil then
		fzf_props["prompt"] = "Opened Files (" .. #buffers .. ")"
		fzf_props["cwd"] = vim.loop.cwd()
		fzf_props["actions"] = {
			["default"] = function(selected)
				local choice = selected[1]
				if choice then
					Select_choice(choice)
				end
			end
		}
		if fzf_props["winopts"] == nil then
			fzf_props["winopts"] = {
				height = 0.35,
				width = 0.50,
				border = "rounded",
			}
		end
		fzf.fzf_exec(buffers, fzf_props)
		return
	end

	vim.ui.select(buffers, { prompt = "Opened Files (" .. #buffers .. ")" }, function(choice)
		if choice then
			Select_choice(choice)
		end
	end)
end

M.setup = function(props)
	if props == nil then
		props = { fzflua = {} }
	end
	local has_fzflua, _ = pcall(require, "fzf-lua")
	if has_fzflua == true then
		fzf_props = props.fzflua
		if fzf_props == nil then
			fzf_props = {}
		end
		fzf = require("fzf-lua")
		-- require("fzf-lua").setup(fzflua_opts)
	end
	vim.api.nvim_create_user_command("BuffersJump", Select, {})
end

return M
