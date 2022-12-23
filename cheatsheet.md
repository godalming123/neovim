***My Neovim Cheatsheet***
A cheatsheet for this configuration and neovim in general.
*Note:* Things marked with ***!SPECIFIC*** are not available on all neovim installations but only this configuration.

# Modes
*Note:* From any mode, use ESC to enter normal mode.
      There are also multiple ways of entering another mode.
      However, the keys shown by the mode headings are the primary ways.

## Normal - ESC
There two things you can do in normal mode; enter another mode or edit and navigate text.
To enter another mode you can use the keys by the headers of this modes list.
As for editing and navigating text, there are several syntaxes to do this:
 - {instruction}
 - {operator}{motion}
 - {motion}
*Note:* All of the above can be used with a number to do the operation specified twice.
 - **Operator:**
        Commands are used in conjunction with motions to edit text.
        *Note:* Commands can usually be pressed twice to do a common action - EG: `dd` deletes a line.
              They often also do something slightly deferrent when they are capitalised.
        - **d** deletes text from the cursor to the motion specified and adds it to the clipboard
        - **c** changes text from the cursor to the motion specified
 - **Motions:**
        Normaly, motions can be used to navigate text however in conjuction with *COMMANDS*, they can be used to modify text.
        *Note:* For some motions you can prefix the with i when using commands and visual.
              For example, `diw` deletes the word no matter where you are inside it rathor then deleting to the end of the word.
         - **h/j/k/l** move left/down/up/right
         - **w**       move to the start of the next word
         - **e**       move to the end of the next word
         - **$**       go to end of line
         - **H/M/L**   go to top/middle/bottom of screen
         - **G**       go to end of file
         - **gg**      go to start of file
 - **Instructions:**
        Instructions are like commands but already come with a motion attached. EG: x(instruction) = d(command)l(motion)
         - **~**        change case of letter under cursor and move cursor forwards
         - **x**        deletes the letter under the cursor - equivilant to dl
         - **u**        undo
         - **U**        undo all history on line
         - **ctrl + r** redo
         - **o**        enter newline below and start inserting
         - **O**        enter newline above and start inserting
         - **p**        pastes text from the neovim clipboard
         - r        replace currently selected letter
         - **0**        move to start of line
         - **t**        ***!SPECIFIC*** select the variable/string/brackets/curly braces/square brackets your cursor is in

## Insert - i
 - The primary mode for typing text.
 - Just type use normal keys such as the arrow keys to move and then press **ESC** when you are done.

## Visual - v
 - The mode used to selected text.
 - Use *MOTIONS* to expand/contract your selection
 - Use *COMMANDS/INSTRUCTIONS* to perform operations on your selection
 - Their are also other operations that can be performed such as:
         - **U** converts selection to uppercase
         - **u** converts selection to lowercase
         - **J** ***!SPECIFIC*** Move selection down
         - **K** ***!SPECIFIC*** Move selection up

## Visual block - ctrl + v
 - Like visual but selects text in a block

## Replace - R
 - Like insert but when you type this removes the charecter in front of your cursor.

## Command - :
 - Used to type vim commands

# Find
 - Use `/` to search forward in a file
 - Use `?` to search backward in a file
 - Ounce you have pressed enter on your search you can use `n` and `N` to navigate the results

# Find and replace
 - **Use:** :{range}s/{pattern}/{string}/{flags} {count}
 - **Range:** (Change occurences...)
         - **%**     In entire file
         - **3,10**  From line 3 to line 10
         - **7**     On line 7
         - **.,+4s** From current line to next four lines
 - **Pattern:**
 - **String:**
         - The string you would like to replace the text with
 - **Flags:**
         - **g** find and replace entire file
 - **Example:**
         - :%s/\(.\)noremap(/vim.keymap.set("\1

# Keyboard shortcuts
 - **Ctrl + g** display current file information
 - **Ctrl + o** go to older cursor position
 - **Ctrl + i** go to more recent cursor position

# !SPECIFIC Keyboard shortcuts
## Search
 - [F]ind [H]elp
 - [F]ind [K]eybindings
 - [F]ind [F]iles
 - [F]ind [T]ext
 - [F]ind [R]ecent
 - [F]ind [D]iagnostics

## Diagnostics:
        - **]d** - next diagnostic
        - **[d** - previous diagnostic

## Navigation
 - **Ctrl + H/J/K/L** - left/lower/upper/right split
 - **Goto:**
         - [G]oto [D]efinition
         - [G]oto [R]eferences (opens a references search window)
         - [G]oto [↑D]eclartion

## Markdown shortcuts
 - **Tab** - Fold headers
 - **Control + c** - Toggle no checkbox, unchecked checkbox and checked checkbox on list item
 - **Control + k** - Create link (You can then use tab to move between the fields in the link)
