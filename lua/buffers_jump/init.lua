local M ={}
local API = {
	str_trim = function(s)
		return s:match("^%s*(.-)%s*$")
	end
}

function Get_Buffers()
	local buffers = vim.api.nvim_list_bufs()
	local count = 0
	local names = {}
	local cb_name = vim.api.nvim_buf_get_name(0)
	for k, v in pairs(buffers) do
		local name = vim.api.nvim_buf_get_name(v)
		local trim = API.str_trim(name)
		if trim ~= "" and trim ~= API.str_trim(cb_name) then
			table.insert(names, trim)
		end
	end
	if API.str_trim(cb_name) ~= "" then
		table.insert(names, 2, cb_name)
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
		require("dressing").setup(dress_opts)
	end
	vim.api.nvim_create_user_command("BuffersJump", Select, {})
end

return M
