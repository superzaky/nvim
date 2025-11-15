return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        }, 
        config = function()
			require('telescope').setup{
				defaults = {
					-- Default configuration for telescope goes here:
					-- config_key = value,
					mappings = {
						i = {
							-- map actions.which_key to <C-h> (default: <C-/>)
							-- actions.which_key shows the mappings for your picker,
							-- e.g. git_{create, delete, ...}_branch for the git_branches picker
							["<C-h>"] = "which_key"
						}
					}
				},
                pickers = {
                    find_files = {
                        theme="ivy"
                    }
					-- Default configuration for builtin pickers goes here:
					-- picker_name = {
						--   picker_config_key = value,
						--   ...
						-- }
						-- Now the picker_config_key will be applied every time you call this
						-- builtin picker
					},
					extensions = {
						-- Your extension configuration goes here:
						-- extension_name = {
							--   extension_config_key = value,
							-- }
							-- please take a look at the readme of the extension you want to configure
						}
			}
            vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
            vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files)
            vim.keymap.set("n", "<space>en", function ()
                require('telescope.builtin').find_files{
                    cwd = vim.fn.stdpath("config")
                }
            end)
        end
    }
}
