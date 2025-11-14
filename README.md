# BuffersJump
## Description
BuffersJump is a plugin for Neovim 0.9+. This plugin helps to jump between opened or loaded buffers in Neovim.

 - [Instalation](https://github.com/aclCMNK/BuffersJump.nvim#Instalation)
 - [Usage](https://github.com/aclCMNK/BuffersJump.nvim#Usage)

## Instalation
### Simple instalation
**Using Lazy**

    {
		    "aclCMNK/BuffersJump.nvim",
		    config = function()
				    require("buffers_jump").setup()
		    end
    }

### Instalation with dressing
**Using Lazy**

    {
			   "aclCMNK/BuffersJump.nvim",
			   dependencies = {
					   "https://github.com/stevearc/dressing.nvim"
					   -- If you want to use telescope
					   "nvim-telescope/telescope.nvim"
					   -- Or if you want to use NUI
					   "MunifTanjim/nui.nvim"
			   },
			   config = function()
					   require("buffers_jump").setup({
							   dressing = {...} -- dressing options
					   })
			   end
    }

### Usage
You can use BuffersJump running this command:

    :BuffersJump
This command runs the plugin depending of the instalation you defined.
You can close the selector pressing "Esc"
