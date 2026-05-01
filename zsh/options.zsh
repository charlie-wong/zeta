# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 显示已启用选项 setopt           显示未启用选项 unsetopt
setopt hist_ignore_dups           # ignore commands that was just recorded
setopt hist_ignore_all_dups       # delete old recorded if new entry is a duplicate one
setopt hist_expire_dups_first     # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_space          # ignore commands that start with space
setopt hist_save_no_dups          # delete older commands that duplicate newer ones in HISTFILE
setopt hist_reduce_blanks         # delete superfluous blanks before write to HISTFILE
setopt hist_verify                # show command with history expansion to user before running it
setopt share_history              # share command history data between all shell sessions
setopt extended_history           # Write HISTFILE file in ":start:elapsed;command" format

setopt shwordsplit # Causes field splitting to be performed on unquoted parameter expansions.
