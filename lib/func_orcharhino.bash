#funktionen rund um die Paketverwaltung etc.



function get_uptime(){
  local zeitzone="${1}"
  [ "${zeitzone}" != "" ] && zeitzone="Europe/Berlin"
  env TZ="${zeitzone}" date -d "$(env TZ="${zeitzone}" uptime -s)" "+%Y-%m-%d %H:%M:%S %Z"
}

function last_rpmupdate(){
   local zeitzone="${1}"
   [ "${zeitzone}" == "" ] && zeitzone="Europe/Berlin"
   while IFS= read zeitstempel; do
     env TZ="${zeitzone}" date -d "${zeitstempel}" "+%Y-%m-%d %H:%M:%S %Z"
   done< <( rpm -qa --last 2>/dev/null | sed -E 's/^[^ ]+//g' | sed -E 's/^[ ]+(.*)/\1/g' | sort -n | uniq | tail -1 - )
}

function last_aptupdate(){
  local zeitzone="${1}"
  [ "${zeitzone}" == "" ] && zeitzone="Europe/Berlin"
  zeitstempel="$(stat -c '%z' /var/cache/apt/pkgcache.bin 2>/dev/null)"
  [ "${zeitstempel}" != "" ] && env TZ="${zeitzone}" date -d "${zeitstempel}" "+%Y-%m-%d %H:%M:%S %Z"
}

function last_packageupdate(){
  local zeitzone="${1}"
  [ "${zeitzone}" == "" ] && zeitzone="Europe/Berlin"
  (
    last_aptupdate "${zeitzone}"
    last_rpmupdate "${zeitzone}"
  ) | grep -E "^[0-9]{4}" | sort -n | uniq | tail -1 -
}


function foreman_hammer_get_proxies(){ 
  hammer --output csv --no-headers proxies list --fields="name" 
}
