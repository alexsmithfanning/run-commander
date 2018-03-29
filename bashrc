#!/usr/bin/env bash
# shellcheck disable=SC2059

################################################################################
# bash color output aliases                                                    #
################################################################################

BLACK='\e[38;5;16m'
RED='\e[38;5;1m'
GREEN='\e[38;5;2m'
ORANGE='\e[38;5;214m'
BLUE='\e[38;5;12m'
BLUE_DARK='\e[38;5;4m'
PINK='\e[38;5;5m'
PURPLE='\e[38;5;93m'
CYAN='\e[38;5;51m'
GRAY_LIGHT='\e[38;5;188m'
GRAY='\e[38;5;244m'
GRAY_DARK='\e[38;5;248m'
GREEN_LIGHT='\e[38;5;120m'
YELLOW='\e[38;5;11m'
YELLOW_LIGHT='\e[38;5;229m'
BLUE_LIGHT='\e[38;5;14m'
PURPLE_LIGHT='\e[38;5;177m'
CYAN_LIGHT='\e[38;5;195m'
WHITE='\e[38;5;15m'
STANDARD=$(tput sgr0)
BOLD='\e[1m'
ITALIC='\e[3m'
UNDERLINE='\e[4m'
STRIKE='\e[9m'
BLINK='\e[5m'
DIM='\e[2m'

################################################################################
# functions and other stuff that needs to be first                             #
################################################################################

warn_root() {

	if [[ ! ${EUID} -ne 0 ]]; then

		printf "\n${RED}${BOLD}WARNING:${STANDARD}${WHITE}${BOLD} You are using the root account. It is possible to do irrecoverable damage to your system.${STANDARD}\n\n"

	fi

}

# Easily reload the bash source file
rebash() {

	printf "\n${PURPLE_LIGHT}Reloading bash...${STANDARD}"
	source "${HOME}/.bashrc" &> /dev/null
	printf "${GREEN_LIGHT}${BOLD} DONE.${STANDARD}\n\n"

}

# Update the root account's .bashrc easily
# may be used for other things in the future
update() {

	case "${1}" in

	"root" | "ROOT" )

		if [[ ! ${EUID} -ne 0 ]]; then

			printf "\n${RED}${BOLD}Your request has been ignored because you are currently root.${STANDARD}\n\n"

		else

			sudo -E cp -f "${HOME}/.bashrc" "/root/.bashrc"
			printf "\n${GREEN_LIGHT}${BOLD}The root account's bash configuration has been updated.${STANDARD}\n\n"

		fi

	;;

	"ls_colors" | "LS_COLORS" | "ls-colors" | "LS-COLORS" )

		# TODO

	;;

	"install" | "INSTALL" )

		local SCRIPTNAME=$(basename "${0}")
		local BACKUPDIR="${HOME}/.config/run-commander/backups"
		local BACKUPFILE="${BACKUPDIR}/bashrc.bak"

		if [ "${SCRIPTNAME}" == "bash" ]; then

			printf "\n${RED}${BOLD}You must run this file as a script to install it. Do not source it.${STANDARD}\n"
			printf "${RED}${BOLD}Or, you've named this script ${WHITE}${BOLD}bash${STANDARD}${RED}${BOLD}.${STANDARD}\n\n"

		fi

		mkdir -p "${BACKUPDIR}/"

		printf "\n${PURPLE_LIGHT}Backing up the old file...${STANDARD}"

		# Don't overwrite old backups
		if [[ -e "${BACKUPFILE}" ]]; then

			local i="0"
			while [[ -e "${BACKUPFILE}.${i}" ]]; do

				# Increment i by one until the file doesn't exist
				let i++

			done

			local BACKUPFILE="${BACKUPDIR}/bashrc.bak.${i}"

			cp -f "${HOME}/.bashrc" "${BACKUPFILE}"

		else

			cp -f "${HOME}/.bashrc" "${BACKUPFILE}"

		fi

		printf "${GREEN_LIGHT}${BOLD} DONE.${STANDARD}"
		printf "\n${PURPLE_LIGHT}Installing this file to ${WHITE}${HOME}/.bashrc${PURPLE_LIGHT}...${STANDARD}"
		cp -f "${PWD}/${SCRIPTNAME}" "${HOME}/.bashrc"
		printf "${GREEN_LIGHT}${BOLD} DONE.${STANDARD}"
		rebash

	;;

	"" )

		printf "\n${RED}${BOLD}You must specify an argument.${STANDARD}\n\n"

	;;

	* )

		printf "\n${WHITE}${BOLD}${1}${STANDARD}${RED}${BOLD} is not a valid argument.${STANDARD}\n\n"

	;;

	esac

}

# Check if trying to install the script
if [ "${1}" == "install" ]; then

	# Run the update function with the install argument
	update install
	exit 0

fi

draw_line() {

	local i
	# Gets the width of the terminal and draws a line across it
	for i in $(seq "${COLUMNS}"); do printf "${GREEN}="; done && echo

}

colortest() {

	# ${1} is the input argument, AKA color to be tested
	# The "!" beside the 1 double evaluates the variable, so instead of
	# evaluating to COLOR="BLACK" if you chose black, it evaluates the black
	# variable itself
	COLOR="${!1}"

	# Check to make sure the number of arguments is only one
	if [ "${#}" -ne "1" ]; then

		printf "${RED}${BOLD}Invalid number of arguments.${STANDARD}\n"

	elif [ "${1}" == "BOLD" ] || [ "${1}" == "UNDERLINE" ] || [ "${1}" == "STRIKE" ] || [ "${1}" == "ITALIC" ] || [ "${1}" == "BLINK" ] || [ "${1}" == "DIM" ]; then

		printf "${RED}${BOLD}That is not a color.${STANDARD}\n"

  	elif [ "${1}" == "MAP" ]; then

        for FGBG in 38 48; do # Foreground / Background

            for PALETTE in {0..255}; do # Colors

                # Display the color
                printf "\e[${FGBG};5;%sm  %3s  \e[0m" ${PALETTE} ${PALETTE}

                # Display 6 colors per line
                if [ $(((${PALETTE} + 1) % 6)) == 4 ]; then

                    echo # New line

                fi

            done

            echo # New line

        done


	else

		printf "${COLOR}this is normal text${STANDARD}\n"
		printf "${COLOR}${BOLD}this text is bold${STANDARD}\n"
		printf "${COLOR}${ITALIC}this text is italicized${STANDARD}\n"
		printf "${COLOR}${STRIKE}this is strikeout text${STANDARD}\n"
		printf "${COLOR}${UNDERLINE}this is underlined text${STANDARD}\n"
		printf "${COLOR}${DIM}this is dimmed text${STANDARD}\n"

	fi

}

################################################################################
# Check if this bashrc file has ever been ran before.                          #
# If not, make sure the user is notified about the capabilites of this script  #
# by temporarily enabling notifications for missing supported programs.        #
################################################################################

if [ ! -e "${HOME}/.config/run-commander/bashrc.config" ]; then

	mkdir -p "${HOME}/.config/run-commander/"
	touch "${HOME}/.config/run-commander/bashrc.config"
	chmod +x "${HOME}/.config/run-commander/bashrc.config"
	printf "# Change the value below to false to supress startup notifications\n" >> "${HOME}/.config/run-commander/bashrc.config"
	printf "NOTIFY_MISSING=true" >> "${HOME}/.config/run-commander/bashrc.config"
	printf "\n# Want bash to insult you like the failure you are? Set this to true.\n" >> "${HOME}/.config/run-commander/bashrc.config"
	printf "ENABLE_INSULTS=false" >> "${HOME}/.config/run-commander/bashrc.config"

	draw_line
	printf "\n\n${PURPLE_LIGHT}To disable notifications for missing programs,\n"
	printf "edit ${WHITE}${BOLD}${HOME}/.config/run-commander/bashrc.config${STANDARD}\n\n"
	draw_line

fi

# Source the configuration file
. "${HOME}/.config/run-commander/bashrc.config"

warn_root

################################################################################
# default ubuntu configuration options                                         #
################################################################################

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

################################################################################
# bash-it configuration options                                                #
################################################################################

# Check to see if bash-it is actually installed first.
if [ -e "${HOME}/.bash_it" ]; then

	# Path to the bash it configuration
	export BASH_IT="/home/alex/.bash_it"

	# Lock and Load a custom theme file
	# location /.bash_it/themes/
	export BASH_IT_THEME='pure'

	# (Advanced): Change this to the name of your remote repo if you
	# cloned bash-it with a remote other than origin such as `bash-it`.
	# export BASH_IT_REMOTE='bash-it'

	# Your place for hosting Git repos. I use this for private repos.
	export GIT_HOSTING='git@git.domain.com'

	# Change this to your console based IRC client of choice.
	export IRC_CLIENT='irssi'

	# Set this to the command you use for todo.txt-cli
	export TODO="t"

	# Set this to false to turn off version control status checking within the
	# prompt for all themes.
	export SCM_CHECK=true

	# Set vcprompt executable path for scm advance info in prompt (demula theme)
	# https://github.com/djl/vcprompt
	#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

	# (Advanced): Uncomment this to make Bash-it reload itself automatically
	# after enabling or disabling aliases, plugins, and completions.
	# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

	# Load Bash It
	source ${BASH_IT}/bash_it.sh

fi

################################################################################
# hstr configuration options                                                   #
################################################################################

# Check to see if hstr is installed
if [ -e "/usr/bin/hh" ]; then

	# Enable high-color mode
	export HH_CONFIG=hicolor

	# Leading space hides commands from history
	export HISTCONTROL=ignorespace

	# mem/file sync
	export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

	# if this is interactive shell, then bind hh to Ctrl-r
	if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi

elif [ "${NOTIFY_MISSING}" == "true" ]; then

	printf "\n${WHITE}${BOLD}hstr${STANDARD} is not installed. You can install it with ${WHITE}${BOLD}sudo add-apt-repository ppa:ultradvorka/ppa && sudo apt-get update && sudo apt-get install hh${STANDARD}.\n\n"

fi

################################################################################
# personal customization options                                               #
################################################################################

# For when networkmanager randomly breaks for no reason
alias RestartNetwork="sudo service network-manager restart"

# Don't use if you aren't me; it's probably broken anyway
alias androidkernelbuildsetup="export PATH=/home/alex/Android/environment/aarch64-linux-android/bin:/home/alex/Android/bootimg_tools_7.8.13/:$PATH && export USE_CCACHE=1 && export SUBARCH=arm64 && export ARCH=arm64 && export CROSS_COMPILE=/home/alex/Android/environment/aarch64-linux-android/bin/aarch64-linux-android-"

if [ ! -e "${HOME}/.bin" ]; then

	# Make a .bin directory in the current user's home directory
	mkdir "${HOME}/.bin"
	printf "\n${WHITE}${BOLD}${HOME}/.bin${STANDARD} was not found, so it has been created.\n\n"

else

	# Add ~/.bin to the terminal path so it looks for binaries.
	PATH="${PATH}:${HOME}/.bin"

fi

if [ -e "${HOME}/.cargo/bin" ]; then

	# Add Rust's cargo directory to the PATH
	PATH="${PATH}:${HOME}/.cargo/bin"

elif [ "${NOTIFY_MISSING}" == "true" ]; then

	printf "\n${WHITE}${BOLD}rust${STANDARD} or its package manager ${WHITE}${BOLD}cargo${STANDARD} is not installed. You can install it with ${WHITE}${BOLD}apt install rustc${STANDARD} or using ${WHITE}${BOLD}rustup${STANDARD}.\n\n"

fi

# Go needs this set to know where packages go.
if [ -e "/usr/bin/go" ]; then
	export GOPATH="${HOME}/.local/share/godata"
	PATH="${PATH}:${HOME}/.local/share/godata/bin"
fi

# Don't check mail when opening terminal.
unset MAILCHECK

if [ -e "/usr/bin/thefuck" ]; then

	# Make sure thefuck works like intended. This is REQUIRED for thefuck to work.
	eval "$(thefuck --alias)"

elif [ "${NOTIFY_MISSING}" == "true" ]; then

	printf "\n${WHITE}${BOLD}thefuck${STANDARD} is not installed. You can install it with ${WHITE}${BOLD}apt install thefuck${STANDARD}.\n\n"

fi

if [ -e "${HOME}/.config/run-commander/LS_COLORS" ]; then

	eval "$(dircolors -b "${HOME}/.config/run-commander/LS_COLORS")"

else

	printf "\n${PURPLE_LIGHT}Downloading extra list directory colors...${STANDARD}"
	wget -q "https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS" -O "${HOME}/.config/run-commander/LS_COLORS"
	printf "${GREEN_LIGHT}${BOLD} DONE.${STANDARD}\n" && sleep 2
	rebash
	printf "${GREEN_LIGHT}${BOLD} DONE.${STANDARD}\n\n"

fi

if [ -e "/usr/local/bin/ntfy" ]; then

	export AUTO_NTFY_DONE_LONGER_THAN=-L10
	export AUTO_NTFY_DONE_UNFOCUSED_ONLY=-b

	# Enables ntfy's shell integration
	eval "$(ntfy shell-integration)"

	# Adds zsh-like preexec fuctionality to bash
	. "${HOME}/.local/share/ntfy/bash-preexec.sh"

	# Required for the auto-done feature
	. "${HOME}/.local/share/ntfy/auto-ntfy-done.sh"

	# Add more than the default ntfy ignore options here
	export AUTO_NTFY_DONE_IGNORE="micro"

elif [ "${NOTIFY_MISSING}" == "true" ]; then

	printf "${WHITE}${BOLD}ntfy${STANDARD} is not installed. It is used to automatically notify you when long commands finish. You can install it with ${WHITE}${BOLD}sudo pip3 install ntfy${STANDARD}.\n"

fi

if [ "${ENABLE_INSULTS}" == "true" ]; then

	if [ ! -f "${HOME}/.config/run-commander/bashrc.insults" ]; then

		printf "\n${PURPLE_LIGHT}Downloading insults...${STANDARD}"
		wget -q "https://raw.githubusercontent.com/hkbakke/bash-insulter/master/src/bash.command-not-found" -O "${HOME}/.config/run-commander/bashrc.insults"
		printf "${GREEN_LIGHT}${BOLD} DONE${STANDARD}.\n" && sleep 2
		rebash

	fi

	. "${HOME}/.config/run-commander/bashrc.insults"

fi

if [ -d "${HOME}/.qfc" ]; then

	. "${HOME}/.qfc/bin/qfc.sh"

fi

if [ -f "/usr/bin/direnv" ]; then
