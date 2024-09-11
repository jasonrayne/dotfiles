return {
	{
   	 'dgagn/diagflow.nvim',
	    event = 'LspAttach',
	    opts = {
    enable = true,
    scope = 'line', -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
    padding_top = 0,
    padding_right = 0,
    text_align = 'right', -- 'left', 'right'
    placement = 'inline', -- 'top', 'inline'
	}
    },
}
