# mymn — my manual

`mymn` is a small `man`-style command for my own notes. It looks up a command in
[`BASH1`](BASH1) and prints its description and usage examples in the terminal.

Tab completion completes entry names

Long output opens in `less`


## How a lookup is matched

`mymn` picks the best level that has any matches and shows all entries at that level:

1. **Exact name** — `mymn tar`
2. **Whole words in the name** — `mymn docker` → `docker ps`, `docker run`, ...
3. **Part of the name** — `mymn kube` → all `kubectl ...` entries.
4. **Anywhere in the text** — if no entry name matches, it shows entries whose description or examples mention the query.


## Writing entries in BASH1

`mymn` relies on the layout of `BASH1`:
  entry name: NOT indented
    description: indented
      # comment   <- example: indented, starts with $


## Installation

```bash
# 1. make the script executable and put it on $PATH (~/.local/bin is on PATH)
chmod +x ~/code/Notes/mymn
ln -s ~/code/Notes/mymn ~/.local/bin/mymn

# 2. enable tab completion: add this line to ~/.bashrc
[ -f ~/code/Notes/mymn-completion.bash ] && source ~/code/Notes/mymn-completion.bash

# 3. reload the shell
source ~/.bashrc
```


## How it works

- **`mymn`** is a bash script. It handles the arguments (`-grep`, `-h`) and then
  runs an `awk` program over `BASH1`. That program splits the file into entries
  and sections, scores each entry name against the query, and prints the best
  matches with colors. Colors are only used when the output goes to a terminal,
  so `mymn docker | grep run` gets plain text.
- **`mymn --entries`** (internal) prints every entry name, one per line.
- **`mymn-completion.bash`** registers `_mymn` with `complete -F`. On TAB, bash
  calls it with the words typed so far. It reads `mymn --entries`, keeps the
  names that start with those words, and suggests the next word. Words with
  shell-special characters (`$`, `|`, `(`) are never suggested, so a
  suggestion can't break the command line.
