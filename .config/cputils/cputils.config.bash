#!/usr/bin/env bash
# cputils.config.bash

export CPP_COMPILER_DEFAULT_ARGS="-std=c++20 -g -Wall"
export INPUT_CACHE_FILE_EXTENSION="cpp.txt"
export HIDE_EXAMPLES=1

create_output_file_name() {
	FILENAME_EXTLESS="$1"
	EXT="$2"

	# printf "a"
	# printf "a.out"
	printf "$FILENAME_EXTLESS"
	# printf "$FILENAME_EXTLESS.out"
	# printf "$FILENAME_EXTLESS.$EXT.out"
}
export -f create_output_file_name

# we attempt to handle at least the most common clipboard tools here.
# add yours if it's missing
# (see https://stackoverflow.com/questions/749544/pipe-to-from-the-clipboard-in-bash-script
#  and https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script )
#
# it'd be great if you could create a pull request too!
# https://github.com/kiprasmel/cputils/blob/master/cputils-run
#

export STATUS_CLIPBOARD_FAILURE=2   # likely to be empty, thought not all tools error in this case :/
export STATUS_CLIPBOARD_UNHANDLED=3

paste_from_clipboard() {
	if false; then
		:
	elif command -v pbpaste &>/dev/null; then pbpaste             || return $STATUS_CLIPBOARD_FAILURE
	elif command -v xclip   &>/dev/null; then
		                xclip -selection clipboard -o 2>/dev/null && return 0 \
		             || xclip -selection primary   -o 2>/dev/null && return 0 \
		             ||                                              return $STATUS_CLIPBOARD_FAILURE
	elif command -v xsel    &>/dev/null; then xsel --clipboard    || return $STATUS_CLIPBOARD_FAILURE
	elif ls /dev/clipboard  &>/dev/null; then cat /dev/clipboard  || return $STATUS_CLIPBOARD_FAILURE
	# elif ... # add your's!
	else return $STATUS_CLIPBOARD_UNHANDLED
	fi

	return $?
}
export -f paste_from_clipboard

open_with_editor() {
	# return 1 # delete this line and choose your editor if you want to

	nvim "$1"
	# vscodium "$1"

	# emacs "$1"
	# geany "$1" &
	# code "$1"
}
export -f open_with_editor

# internal function for 'create_hash'
# https://stackoverflow.com/a/2394040/9285308
strip_whitespace_and_comments() {
	get_extension() {
		printf "${1##*.}"
	}

	FILE="$1"
	FILE_EXT="$(get_extension "$FILE")"

	if [ "$FILE_EXT" = "cpp" ] || [ "$FILE_EXT" = "c" ]; then
		# strip comments and whitespace
		g++ -fpreprocessed -dD -E -P "$FILE"

		#
		# note: on macos, g++ is available, just need to symlink (or edit call here).
		#
		# intel mac:
		# ln -s /usr/local/bin/gcc-12 /usr/local/bin/gcc
		# ln -s /usr/local/bin/g++-12 /usr/local/bin/g++
		#
		# M1 mac:
		# ln -s /opt/homebrew/bin/gcc-12 /usr/local/bin/gcc
		# ln -s /opt/homebrew/bin/g++-12 /usr/local/bin/g++
		#
	else
		# do nothing
		cat "$FILE"
	fi
}

# create a hash from stdin.
# used to check if a source file
# should be recompiled or not
create_hash() {
	#return 1 # comment out this line to enable and choose the appropriate method

	if [ -z "$1" ]; then
		# stdin

		xargs strip_whitespace_and_comments      | openssl dgst -sha256 -r      | awk '{ print $1 }'
		# xargs strip_whitespace_and_comments      | sha256sum -                  | awk '{ print $1 }'
	else
		# $1

		      strip_whitespace_and_comments "$1" | openssl dgst -sha256 -r      | awk '{ print $1 }'
		#       strip_whitespace_and_comments "$1" | sha256sum "$1"               | awk '{ print $1 }'
	fi

	# note: might be different for Mac,
	# see https://stackoverflow.com/a/20217018/9285308
}
export -f create_hash

