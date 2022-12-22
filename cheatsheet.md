# My Neovim Cheatsheet
A cheatsheet for this configuration and vim in general

## Keyboard
### History
 - **u** - undo
 - **U** - undo all history on line
 - **ctrl + r** - redo
### Search
 - [F]ind [H]elp
 - [F]ind [K]eybindings
 - [F]ind [F]iles
 - [F]ind [T]ext
 - [F]ind [R]ecent
 - [F]ind [D]iagnostics

### Navigation
 - **H/J/K/L** - left/down/up/right
 - **Ctrl + H/J/K/L** - left/lower/upper/right split
 - **Goto:**
         - [G]oto [D]efinition
         - [G]oto [R]eferences (opens a references search window)
         - [G]oto [↑D]eclartion

### Edit selection
#### Case:
 - **U** Make selection [U]ppercase
 - **u** Make selection lowercase
 - **~** Change selection case
#### Location:
 - **J** Move selection down
 - **K** Move selection up
#### Delete and insert:
 - **c** Delete selection and insert
 - **C** Delete selected line(s) and insert
 - **r** Replace every selected letter with another letter

### Insertion (ways to enter insert mode)
 - **i** - Insert
 - **o** - Insert below
 - **O** - Insert above

### Markdown shortcuts
 - **Tab** - Fold headers
 - **Control + c** - Toggle no checkbox, unchecked checkbox and checked checkbox on list item
 - **Control + k** - Create link (You can then use tab to move between the fields in the link)

## Find and replace
 - **Use:** :{range}s/{pattern}/{string}/{flags} {count}

 - **Range:** (Change occurences...)
         - **%**     In entire file
         - **3,10**  From line 3 to line 10
         - **7**     On line 7
         - **.,+4s** From current line to next four lines
 - **Pattern:**
 - **Example:**
         - :%s/\(.\)noremap(/vim.keymap.set("\1
