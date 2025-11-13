local M ={}

function Get_Buffers()
	local buffers = vim.api.nvim_list_bufs()
	local count = 0
	local names = {}
	for k, v in pairs(buffers) do
		local name = vim.api.nvim_buf_get_name(v)
		local trim = _G.str_trim(name)
		if trim ~= "" then
			table.insert(names, trim)
		end
	end
	return names
end

function Select()
	local buffers = Get_Buffers()

	if #buffers == 0 then
		_G.console.log("I do not have non-empty buffers")
		return
	end

	vim.ui.select(buffers, { prompt = "Elige un buffer:" }, function(choice)
		if choice then
			vim.cmd("edit " .. choice)
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
