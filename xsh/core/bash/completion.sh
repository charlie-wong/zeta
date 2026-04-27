# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# https://github.com/scop/bash-completion.git
# Enable programmable completion features for interactive shells.
if ! shopt -oq posix; then # apt show bash-completion
  # NOTE It maybe enabled by /etc/bash.bashrc or /etc/profile
  [[ -z "${BASH_COMPLETION_VERSINFO[@]}" ]] && {
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
      source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
      source /etc/bash_completion
    fi
  }
fi
