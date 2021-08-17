set -l tfenv_commands init install list list-remote uninstall use version-name
complete -f -c tfenv -n "not __fish_seen_subcommand_from $tfenv_commands" -a init -d 'Update environment to use tfenv correctly'
complete -f -c tfenv -n "not __fish_seen_subcommand_from $tfenv_commands" -a install -d 'Install a specific version of Terraform'
complete -f -c tfenv -n "not __fish_seen_subcommand_from $tfenv_commands" -a list -d 'List all installed versions'
complete -f -c tfenv -n "not __fish_seen_subcommand_from $tfenv_commands" -a list-remote -d 'List all installable versions'
complete -f -c tfenv -n "not __fish_seen_subcommand_from $tfenv_commands" -a uninstall -d 'Uninstall a specific version of Terraform'
complete -f -c tfenv -n "not __fish_seen_subcommand_from $tfenv_commands" -a use -d 'Switch a version to use'
complete -f -c tfenv -n "not __fish_seen_subcommand_from $tfenv_commands" -a version-name -d 'Print current version'
