#!/bin/bash
#
# ctype_ipv4.bash
#
# IPv4 Testtypen in Bash
#
# 2023-06-22 23:49 CEST	 Oliver Lenz	Initial
# 2023-06-23 21:37 CEST	 Oliver Lenz	Update ipv4 netmask => so gehts schneller
#


#
# Handelt es sich um eine numerische CIDR?
#
#
ctype_ipv4_cidr(){
	[[ "${1}" == 0 || ${1} =~ ^([0-9]+)$ && ${BASH_REMATCH[1]:0:1} != "0" && ${BASH_REMATCH[1]} -le 32 ]] && true || false
}

#
# Handelt es sich um eine valide IPv4-Addresse?
#
#
ctype_ipv4_address(){
	[[
		${1} =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$  && \
		( ${BASH_REMATCH[1]} == "0" || ${BASH_REMATCH[1]:0:1} != "0" ) && ${BASH_REMATCH[1]} -le 255 &&  \
		( ${BASH_REMATCH[2]} == "0" || ${BASH_REMATCH[2]:0:1} != "0" ) && ${BASH_REMATCH[2]} -le 255 &&  \
		( ${BASH_REMATCH[3]} == "0" || ${BASH_REMATCH[3]:0:1} != "0" ) && ${BASH_REMATCH[3]} -le 255 &&  \
		( ${BASH_REMATCH[4]} == "0" || ${BASH_REMATCH[4]:0:1} != "0" ) && ${BASH_REMATCH[4]} -le 255 
	]] && true || false
}

#
# Handelt es sich um eine valide IPv4-Netzmaske?
# Beispiel: 255.128.0.0
#
# Achtung: 
# IPv4 kann auch "verdrehte" Netzmasken, wie z.B. 255.0.255.0
# Wir Prüfen hier aber auf linksbündige ununterbrochene Masken.
#
ctype_ipv4_netmask(){
	if [[ ${1} =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then 
		local s="" i=0 k=0 
		for((i=1;i<=4;i++)); do
			for((k=7;k>=0;k--)); do
				if [[ ${BASH_REMATCH[$i]} == "0" || ${BASH_REMATCH[$i]:0:1} != "0" && ${BASH_REMATCH[$i]} -le 255 ]]; then
					(( $((2**${k})) & ${BASH_REMATCH[${i}]} )) && s+="1" || s+="0"
				else
					false && return
				fi
			done
		done
		i=0 
		while [ "${s:0:1}" == "1" ]; do (( i+=1 )); s=${s:1}; done
		while [ "${s:0:1}" == "0" ]; do (( i+=1 )); s=${s:1}; done
		[ $i -eq 32 ] && true && return
	fi
	false
}

