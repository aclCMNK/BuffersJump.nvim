local M ={}
local API = {
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

function Get_Buffers()
	local buffers = vim.api.nvim_list_bufs()
	local count = 0
	local names = {}
	local cb_name = vim.api.nvim_buf_get_name(0)
	for kb, vb in pairs(buffers) do
		local loaded = vim.api.nvim_buf_is_loaded(vb)
		if loaded == true then
			local name = vim.api.nvim_buf_get_name(vb)
			local trim = API.str_trim(name)
			if trim ~= "" and
				trim ~= API.str_trim(cb_name) and 
				API.contains(trim, "term:") ~= true then
				table.insert(names, trim)
			end
		end
	end
	if API.str_trim(cb_name) ~= "" then
		local pos = 2
		if #names == 0 then
			pos = 1
		end
		table.insert(names, pos, cb_name)
	end
	return names
end

function Select()
	local buffers = Get_Buffers()

	if #buffers == 0 then
		vim.notify("I do not have non-empty buffers", vim.log.levels.INFO)
		return
	end

	vim.ui.select(buffers, { prompt = "Active Buffers ("..#buffers..")" }, function(choice)
		if choice then
			local command = "edit " .. choice
			local open, _ = pcall(vim.cmd, command)
			if open == true then
				vim.cmd(command)
			end
		end
	end)
end

M.setup = function(props)
	if props == nil then
		props = {dressing = {}}
	end
	local has_dressing, _ = pcall(require, "dressing")
	if has_dressing == true then
		local dress_opts = props.dressing
		if dress_opts == nil then
			dress_opts = {}
		end
		require("dressing").setup(dress_opts)
	end
	vim.api.nvim_create_user_command("BuffersJump", Select, {})
end

return M
