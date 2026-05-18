#!/usr/bin/env zsh
# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2026 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# https://unix.stackexchange.com/questions/333241
# In the Bash   it is a function named command_not_found_handle()
# https://www.gnu.org/software/bash/manual/bash.html#Command-Search-and-Execution
# In the ZShell it is a function named command_not_found_handler()
# https://zsh.sourceforge.io/Doc/Release/Command-Execution.html

function setup-command-not-found-handler() {
  [[ ! -x $1 ]] && return 1
  eval "
  function command_not_found_handler() {
    if [[ -x $1 ]]; then
      $1 -- "\$1"
      return \$?
    else
      printf \"zsh: command not found: %s\\\n\" \"\$1\" >&2
      return 127
    fi
  }
  "
}

# Debian and its derivatives, https://launchpad.net/ubuntu/+source/command-not-found
setup-command-not-found-handler /usr/lib/command-not-found && return
setup-command-not-found-handler /usr/share/command-not-found/command-not-found && return

# Arch Linux, and must have pkgfile package installed first.
# https://wiki.archlinux.org/title/Zsh#pkgfile_"command_not_found"_handler
if [[ -r /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
  source /usr/share/doc/pkgfile/command-not-found.zsh
  return 0
fi
