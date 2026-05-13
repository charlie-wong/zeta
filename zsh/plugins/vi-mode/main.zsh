# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# ESC 键 -> 模式切换
#
# 模式 vicmd 映射
# i   vi-insert           进入插入模式
# I   vi-insert-bol       进入插入模式(光标移动到行首非空字符)
# a   vi-add-next         进入插入模式(光标移动到当前位置之后)
# A   vi-add-eol          进入插入模式(光标移动到行尾)
#
# v   visual-mode         visual selection mode
# V   visual-line-mode    visual selection mode
#
# R   vi-replace          Enter overwrite mode
# r   vi-replace-chars    替换当前光标处的字符

# 按键序列等待时间，单位百分之一秒，默认值 40
KEYTIMEOUT=50 # 50/100 = 0.5 秒

# echo -n ${terminfo[kcuu1]} | hexyl 显示转义序列值
#zmodload zsh/termcap # echo "${(k)termcap[(I)k*]}"
zmodload zsh/terminfo # echo "${(k)terminfo[(I)k*]}"

# Executed when ZLE is started to read a new line of input
function zle-line-init() {
  # enter keypad transmit mode
  (( ${+terminfo[smkx]} )) && echoti smkx
  # emulate -L zsh; printf '%s' ${terminfo[smkx]}
}
zle -N zle-line-init

# Executed when ZLE has finished reading a new line of input
# Launch when press Enter before user input command executed
function zle-line-finish() {
  # leave keypad transmit mode
  (( ${+terminfo[rmkx]} )) && echoti rmkx
  # emulate -L zsh; printf '%s' ${terminfo[rmkx]}
}
zle -N zle-line-finish

function zvm-set-cursor-style() {
  local -A cs=(
    # https://vt100.net/docs/vt510-rm/DECSCUSR  搜索 DECSCUSR
    # https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
    "ud"    '\e[0 q' # 用户默认
    "bbl"   '\e[1 q' # block blink
     "bl"   '\e[2 q' # block
    "bul"   '\e[3 q' # underline blink
     "ul"   '\e[4 q' # underline
    "bbe"   '\e[5 q' # beam blink
     "be"   '\e[6 q' # beam
  )

  case "${1}" in
    emacs)    printf "${cs[bbe]}" ;; # beam blink
    viins)    printf "${cs[bbe]}" ;; # beam blink
    main)     printf "${cs[bbe]}" ;; # beam blink
    vicmd)    printf "${cs[bbl]}" ;; # block blink
    visual)   printf  "${cs[bl]}" ;; # block
    viopp)    printf "${cs[bul]}" ;; # underline blink
    isearch)  printf  "${cs[ul]}" ;; # underline
    command)  printf  "${cs[be]}" ;; # beam
    *)        printf  "${cs[ud]}" ;;
  esac
}

# Executed every time the keymap changes
function zle-keymap-select() {
  # KEYMAP new keymap, $1 old keymap
  zvm-set-cursor-style "${KEYMAP}"
}
zle -N zle-keymap-select

# main is default keymap when ZLE starts up
bindkey -v # make viins keymap as main & default

function zvm-bindkey() {
  local kmap="$1" ties="$2" hook="$3"
  if [[ -z "${ties}" ]]; then
    @zeta:wmsg "skip bind <${hook}> to none."
    return
  fi
  bindkey  -M  "${kmap}"  "${ties}"  "${hook}"
}

function zvm-main() {
  # https://invisible-island.net/ncurses/ncurses.faq.html
  # https://invisible-island.net/ncurses/man/terminfo.5.html
  # https://invisible-island.net/xterm/xterm-function-keys.html
  local -A key=(
    Back    "${terminfo[kbs]}"        Ctrl+Back   '^H'

    Up      "${terminfo[kcuu1]}"      Ctrl+Up     "${terminfo[kUP5]}"
    Down    "${terminfo[kcud1]}"      Ctrl+Down   "${terminfo[kDN5]}"
    Left    "${terminfo[kcub1]}"      Ctrl+Left   "${terminfo[kLFT5]}"
    Right   "${terminfo[kcuf1]}"      Ctrl+Right  "${terminfo[kRIT5]}"

    Ins     "${terminfo[kich1]}"      Ctrl+Ins    "${terminfo[kIC5]}"
    Del     "${terminfo[kdch1]}"      Ctrl+Del    "${terminfo[kDC5]}"
    Home    "${terminfo[khome]}"      Ctrl+Home   "${terminfo[kHOM5]}"
    End     "${terminfo[kend]}"       Ctrl+End    "${terminfo[kEND5]}"
    PgUp    "${terminfo[kpp]}"        Ctrl+PgUp   "${terminfo[kPRV5]}"
    PgDn    "${terminfo[knp]}"        Ctrl+PgDn   "${terminfo[kNXT5]}"
  )

  local kmap
  for kmap in vi{cmd,ins}; do
    zvm-bindkey  ${kmap}  "${key[Home]}"          beginning-of-line
    zvm-bindkey  ${kmap}  "${key[End]}"           end-of-line

    zvm-bindkey  ${kmap}  "${key[Ctrl+Home]}"     backward-kill-line
    zvm-bindkey  ${kmap}  "${key[Ctrl+End]}"      kill-line

    zvm-bindkey  ${kmap}  "${key[Left]}"          backward-char
    zvm-bindkey  ${kmap}  "${key[Right]}"         forward-char

    zvm-bindkey  ${kmap}  "${key[Ctrl+Left]}"     backward-word
    zvm-bindkey  ${kmap}  "${key[Ctrl+Right]}"    forward-word

    zvm-bindkey  ${kmap}  "${key[Up]}"            up-line-or-history
    zvm-bindkey  ${kmap}  "${key[Down]}"          down-line-or-history

    zvm-bindkey  ${kmap}  "${key[PgUp]}"          up-line-or-search
    zvm-bindkey  ${kmap}  "${key[PgDn]}"          down-line-or-search
  done

  zvm-bindkey  viins  "${key[Back]}"              backward-delete-char
  zvm-bindkey  viins  "${key[Del]}"               delete-char

  zvm-bindkey  viins  "${key[Ctrl+Back]}"         backward-delete-word
  zvm-bindkey  viins  "${key[Ctrl+Del]}"          delete-word
}

zvm-main; unset -f zvm-main zvm-bindkey

bindkey  -M  vicmd  'h'   backward-char           # left
bindkey  -M  vicmd  'j'   down-line-or-history    # down
bindkey  -M  vicmd  'k'   up-line-or-history      # up
bindkey  -M  vicmd  'l'   forward-char            # right

bindkey  -M  vicmd  'H'   backward-word           # left
bindkey  -M  vicmd  'L'   forward-word            # down

bindkey  -M  vicmd  '^'   beginning-of-line
bindkey  -M  vicmd  '$'   end-of-line

bindkey  -M  vicmd  'x'   backward-delete-char
bindkey  -M  vicmd  'X'   backward-delete-word

bindkey  -M  vicmd  '^P'  up-history              # Ctrl + P
bindkey  -M  vicmd  '^N'  down-history            # Ctrl + N

bindkey  -M  viins  '^a'  beginning-of-line       # Ctrl + a
bindkey  -M  viins  '^e'  end-of-line             # Ctrl + e

bindkey  -M  viins  '^w'  backward-delete-word    # Ctrl + w
