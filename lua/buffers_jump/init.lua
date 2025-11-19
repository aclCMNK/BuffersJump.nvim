local M ={}
local fzf = nil
local fzf_props = {}
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
	-- if API.str_trim(cb_name) ~= "" then
	-- 	local pos = 2
	-- 	if #names == 0 then
	-- 		pos = 1
	-- 	end
	-- 	table.insert(names, pos, cb_name)
	-- end
	return names
end

function Select()
	local buffers = Get_Buffers()

	if #buffers == 0 then
		vim.notify("I do not have non-empty buffers", vim.log.levels.INFO)
		return
	end
	if fzf ~= nil then
		fzf_props["prompt"] = "Opened Files ("..#buffers..")"
		fzf_props["cwd"] = vim.loop.cwd()
		fzf_props["actions"] = {
			["default"] = function(selected)
				local choice = selected[1]
				if choice then
					local command = "buffer " .. choice
					local open, _ = pcall(vim.cmd, command)
					if open == true then
						vim.cmd(command)
					end
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

	vim.ui.select(buffers, { prompt = "Opened Files ("..#buffers..")" }, function(choice)
		if choice then
			local command = "buffer " .. choice
			local open, _ = pcall(vim.cmd, command)
			if open == true then
				vim.cmd(command)
			end
		end
	end)
end

M.setup = function(props)
	if props == nil then
		props = {fzflua = {}}
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
