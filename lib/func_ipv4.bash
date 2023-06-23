#!/bin/bash
#
# func_ipv4.bash
#
# ipv4-Funktionen 
#
#
# 2023-06-23 13:18 CEST	Oliver Lenz	Initial
#
#

#
# Bibliothek gesucht...
#
func_load_ipv4_libs() {
	if [[ $(type -t ctype_ipv4_address) != function ]]; then
		local owd=$(pwd) scriptdir=$( readlink “${0}” ) ; 
		[ -n ${SCRIPTDIR} ] && cd "$( dirname "${SCRIPTDIR}" )" || cd "$(dirname $0)"
		SCRIPTDIR=$( pwd ) && cd ${owd}
		fn="${SCRIPTDIR}/ctype_ipv4.bash"
		if [ -f "${fn}" ]; 
			. ${fn}
		else
			echo "Bibliothek ${fn} nicht gefunden."
			exit 8
		fi
	fi
}
func_load_ipv4_libs

#
# Aus einer ipv4-adresse einen numerischen Wert berechnen
# 127.0.0.1 => 2130706433
#
func_ipv4_address_to_num(){
	if ctype_ipv4_address ${1} && [[ ${1} =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
		local sum=0 a=$(( ${BASH_REMATCH[1]} << 24))  b=$(( ${BASH_REMATCH[2]} << 16)) ; c=$(( ${BASH_REMATCH[3]} <<  8))
		(( sum=a+b+c+${BASH_REMATCH[4]} )) #in mehreren zeilen, weil sonst formatfehler in mobaxterm
		# printf '%d\n' "$((${BASH_REMATCH[1]} * 256 ** 3 + ${BASH_REMATCH[2]} * 256 ** 2 + ${BASH_REMATCH[3]} * 256 + ${BASH_REMATRCH[4]}))"
		echo "${sum}" && true && return
	fi
	false
}

#
# Aus einem numerischen Wert eine IPv4-Adresse berechnen
# 2130706433 => 127.0.0.1
#
func_ipv4_num_to_address(){
	local oct ip delim="" dec=((${1}+0))
	if [ dec -ge 0 -o dec -le 4294967295 ]; then
		for exp in {3..0}; do
			(( oct = dec / (256**3) ))
			(( dec -= oct * 256 ** exp ))
			echo -n "${delim}${oct}"
			delim="."
		done
	fi
	true && return
}

#
# Aus einem numerischen Adress-Wert eine Binärzahl darstellen
# 255.0.0.0 => 11111111000000000000000000000000
#
func_ipv4_address_to_bin(){
	local i=0 result=0 s=""
	if result=$(func_ipv4_address_to_num "${1}"); then
		(( result+=0 ))
		for((i=31;i>=0;i--)); do
			(( $((2**${i})) & ${result} )) && s+="1" || s+="0"
		done
		echo "${s}" && true && return
	fi
	false
}


#
# Aus einer netzwerkadresse die CIDR berechnen
# 255.0.0.0 => 8
#
func_ipv4_netmask_to_cidr(){
	local bits=0 s="" cidr=0 result=""
	if result=$(func_ipv4_address_to_bin "${1}"); then
		while [ "${result:0:1}" == "1" ]; do (( bits+=1 )); (( cidr+=1 )); result=${result:1};  done
		while [ "${result:0:1}" == "0" ]; do (( bits+=1 )); result=${result:1};  done
		[ ${bits} -eq 32 ] && echo "${cidr}" && true && return
	fi
	false
}


#
# Aus einer CIDR eine Netmaske berechnen
# 8 => 255.0.0.0
#
func_ipv4_cidr_to_netmask(){
	if result=$(func_ipv4_cidr $1); then
		local i=0 n=32 sum=0
		(( i=$1+0 ))
		for((;i>0;i--)); do (( sum+=2**(n-i) )); done
		if result=$(func_ipv4_num_to_address ${sum}); then
			echo ${result} && true && return
		fi
	fi
	false
}


#
# Egal ob CIDR oder Netmask - immer Netmask ausgeben
# 8         => 8
# 255.0.0.0 => 8
#
func_ipv4_form_cidr(){
	if ctype_ipv4_cidr $1; then
		echo "${1}" && true && return
	elif result=$(func_ipv4_netmask_to_cidr $1); then
		echo "${result}" && true && return
	fi
	false
}


#
# Egal von Netmask oder CIDR - immer CIDR ausgeben
# 255.0.0.0 => 255.0.0.0
# 8         => 255.0.0.0
#
func_ipv4_form_netmask(){
	if ctype_ipv4_netmask $1; then
		echo "${1}" && true && return
	elif result=$(func_ipv4_cidr_to_netmsk $1); then
		echo "${result}" && true && return
	fi
}


