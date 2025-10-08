#funktionen rund um die paketverwaltung

function last_rpmupdate(){
  local timezone="${1}"
  [ "${timezone} == "" ] && timezone="Europe/Berlin"
  while IFS= read datum; do
    env TZ="${timezone}" date -d "${datum}" "+%Y-%m-%d %H:%M:%S %Z"
  done< <( rpm -qa --last 2>/dev/null | sed -E 's/^[^ ]+//g' | sed -E 's/^[ ]+(.*)/\1/g' | uniq ) | sort | uniq | tail -1 -
}

function foreman_hammer_get_proxies(){ 
  hammer --output csv --no-headers proxies list --fields="name" 
}
