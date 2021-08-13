# shellcheck shell=bash
# shellcheck disable=SC2140,SC2155
# From https://bitbucket.org/flowblok/shell-startup/src/default/.shell/env_functions
# Which is based upon https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html

# Usage: indirect_expand PATH -> $PATH
indirect_expand() {
    env | sed -n "s/^$1=//p"
}

# Usage: path_remove /path/to/bin [PATH]
# To remove ~/bin from $PATH
#     path_remove ~/bin PATH
path_remove() {
    local IFS=':'
    local newpath
    local dir
    local var=${2:-PATH}
    for dir in $(indirect_expand "$var"); do
        IFS=''
        if [ "$dir" != "$1" ]; then
            newpath=$newpath:$dir
        fi
    done
    export "$var"="${newpath#:}"
}

# Usage: path_prepend /path/to/bin [PATH]
# To prepend ~/bin to $PATH
#     path_prepend ~/bin PATH
path_prepend() {
    path_remove "$1" "$2"
    local var="${2:-PATH}"
    local value=$(indirect_expand "$var")
    export "${var}"="${1}${value:+:${value}}"
}

# Usage: path_append /path/to/bin [PATH]
# To append ~/bin to $PATH
#     path_append ~/bin PATH
path_append() {
    path_remove "${1}" "${2}"
    local var=${2:-PATH}
    local value=$(indirect_expand "$var")
    export "$var"="${value:+${value}:}${1}"
}
