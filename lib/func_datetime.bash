#!/bin/bash
# 2026-01-17 21:12 Oliver Lenz

function wodowim(){ # week of day of week (in Month) # wie oft wiederholt sich der wochentag des datums im monat
  local datum="${1}" epoch dow # yy-mm-dd
  [ ! -n "${datum}" ] &&  datum="$(date "+%Y-%m-%d 00:00:00")"
  [[ $(date -d "${datum}" "+%s %w") =~ ^([0-9]+)\ ([0-9]+)$ ]] && epoch="${BASH_REMATCH[1]}" && dow="${BASH_REMATCH[2]}"
  echo "${datum:0:7} $(( ((${epoch}-$(date -d "${datum:0:7}-01 00:00:00" "+%s"))/86400)/7+1 )) ${dow}"
}

function get_dfdowiwom(){ # get date from  day of week in week of month # welches datum hat der xte wochentag y in yyyy-mm.
  local jahr_monat="${1}"
  local woche="${2}"
  local wochentag="${3}"
  [[ $(date -d "${jahr_monat}-01 00:00:00" "+%s %u") =~ ^([0-9]+)\ ([0-9]+)$ ]] \
    && startdatum="${BASH_REMATCH[1]}" \
    && startwochentag="${BASH_REMATCH[2]}"
  count=1;
  while [[ ${startwochentag} -ne ${wochentag} ]]; do
    ((  count++ )) ; (( startwochentag++ ))
    [ ${startwochentag} -gt 7 ] && startwochentag=1
  done
  echo "${jahr_monat}-$(( count+(${woche}-1)*7 ))"
}

