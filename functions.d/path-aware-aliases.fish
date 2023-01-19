# alias store
set -g __path_aware_aliases_store

# delete previous aliases
function __path_aware_aliases_cleanup
  for pwa_alias_name in $__path_aware_aliases_store
    functions -e $pwa_alias_name
    echo "deleted alias: $pwa_alias_name"
  end

  # recreate empty alias store
  set -e __path_aware_aliases_store
  set -g __path_aware_aliases_store
end

function __path_aware_aliases_present
  if [ (count $__path_aware_aliases_store) -gt 0 ]
    return 0
  else
    return 1
  end
end

function __path_aware_aliases_setup --on-variable PWD --description "setup path aware aliases"
  status --is-command-substitution; and return

  # don't load path aware aliases for root user
  if [ $EUID = 0 ]; return; end

  __path_aware_aliases_cleanup

  # parse aliases from file
  if [ -f "./.fish.aliases" ]
    set -l _info_line

    set -l lines (string split \n (cat "./.fish.aliases"))
    for line in $lines
      # simple key=value pair syntax, empty lines and lines starting with '#' are ignored
      set -l _pwa_key_value_pair (string split -m 1 '=' $line)
      set -l pwa_alias_name (string trim $_pwa_key_value_pair[1])
      set -l pwa_command (string trim $_pwa_key_value_pair[2])

      # skip irrelevant lines
      if [ (string length $pwa_alias_name) = 0 ]; continue; end
      if string_starts_with $pwa_alias_name "#"; continue; end

      # register and create alias
      set -a __path_aware_aliases_store "$pwa_alias_name"
      alias "$pwa_alias_name" "$pwa_command"

      set -a _info_line "$pwa_alias_name = $pwa_command"
    end

    if __path_aware_aliases_present
      echo ">> available aliases in this directory:"
      printf '  %s\n' $_info_line
    end
  end
end
