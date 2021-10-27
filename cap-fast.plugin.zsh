
_cap_refresh () {
  if [ -f .cap_tasks~ ]; then
    rm .cap_tasks~
  fi
  echo "Generating .cap_tasks~..." > /dev/stderr
  _cap_generate
  cat .cap_tasks~
}

_cap_does_task_list_need_generating () {
  if [ ! -f .cap_tasks~ ]; then return 0;
  else
    accurate=$(stat -f%m .cap_tasks~)
    changed=$(stat -f%m Capfile)
    return $(expr $accurate '>=' $changed)
  fi
}

_cap_generate () {
  opts=$(noglob cap --tasks | perl -pe 's/\x1b\[[0-9;]*m//g' | awk 'BEGIN {x=1}; $x>1 { if($1=="cap") { print $2}}')
  echo "$opts" > .cap_tasks~
}

_cap () {
  if [ -f Capfile ]; then
    if _cap_does_task_list_need_generating; then
      echo "\nGenerating .cap_tasks..." > /dev/stderr
      _cap_generate
    fi
    compadd `cat .cap_tasks~`
  fi
}

compdef _cap cap
alias cap_refresh='_cap_refresh'
