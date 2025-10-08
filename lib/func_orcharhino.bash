#funktionen rund um die Paketverwaltung etc.

function get_uptime(){
  local zeitzone="${1}"
  [ "${zeitzone}" != "" ] && zeitzone="Europe/Berlin"
  env TZ="${zeitzone}" date -d "$(env TZ="${zeitzone}" uptime -s)" "+%Y-%m-%d %H:%M:%S %Z"
}

function last_rpmupdate(){
   local zeitzone="${1}"
   [ "${zeitzone}" == "" ] && zeitzone="Europe/Berlin"
   while IFS= read datum; do
     env TZ="${zeitzone}" date -d "${datum}" "+%Y-%m-%d %H:%M:%S %Z"
   done< <( rpm -qa --last 2>/dev/null | sed -E 's/^[^ ]+//g' | sed -E 's/^[ ]+(.*)/\1/g' | sort | uniq | tail -1 - )
}

function foreman_hammer_get_proxies(){ 
  hammer --output csv --no-headers proxies list --fields="name" 
}
