# BuffersJump
## Description
BuffersJump is a plugin for Neovim 0.9+. This plugin helps to jump between opened or loaded buffers in Neovim.

 - [Installation](#Instalation)
 - [Usage](#Usage)

## Installation
### Simple installation
**Using Lazy**

    {
		    "aclCMNK/BuffersJump.nvim",
		    config = function()
				    require("buffers_jump").setup()
		    end
    }

### Installation with FZFLua
**Using Lazy**

    {
			   "aclCMNK/BuffersJump.nvim",
			   dependencies = {
					   "ibhagwan/fzf-lua"
			   },
			   config = function()
					   require("buffers_jump").setup({
							   fzflua = {...} -- FZFLua options
					   })
			   end
    }

## Usage
You can use BuffersJump running this command:

    :BuffersJump
This command runs the plugin depending of the instalation you defined.
You can close the selector pressing "Esc"
