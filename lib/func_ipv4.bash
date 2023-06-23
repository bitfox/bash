#!/bin/bash
#
# func_ipv4.bash
#
# ipv4-Funktionen 
#
#
# 2023-06-23 13:18 CEST	Oliver Lenz	Initial
# 2023-06-23 21:18 CEST	Oliver Lenz	Neue Funkionen angehangen
# 2023-06-23 22:02 CEST	Oliver Lenz	Zusammenführen von ctype_ipv4 und func_ipv4
#
#



#
# Handelt es sich um eine numerische CIDR?
#
#
function ctype_ipv4_cidr(){
	[[ "${1}" == 0 || ${1} =~ ^([0-9]+)$ && ${BASH_REMATCH[1]:0:1} != "0" && ${BASH_REMATCH[1]} -le 32 ]] && true || false
}

#
# Handelt es sich um eine valide IPv4-Addresse?
#
#
function ctype_ipv4_address(){
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
function ctype_ipv4_netmask(){
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



#
# Aus einer ipv4-adresse einen numerischen Wert berechnen
# 127.0.0.1 => 2130706433
#
function func_ipv4_address_to_num(){
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
function func_ipv4_num_to_address(){
	local oct ip delim="" dec=${1}
	if [[ $1 =~ ^([0-9]+)$ && ( ${BASH_REMATCH[1]}=="0" || ${BASH_REMATCH[1]:0:1} != "0" ) ]] && [ ${dec} -ge 0 -o ${dec} -le 4294967295 ]; then
		for exp in {3..0}; do
			(( oct  = dec / (256 ** exp) ))
			(( dec -= oct *  256 ** exp  ))
			echo -n "${delim}${oct}"
			delim="."
		done
		true && return
	fi
	false
}

#
# Aus einem numerischen Adress-Wert eine Binärzahl darstellen
# 255.0.0.0 => 11111111000000000000000000000000
#
function func_ipv4_address_to_bin(){
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
function func_ipv4_netmask_to_cidr(){
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
function func_ipv4_cidr_to_netmask(){
	if result=$(ctype_ipv4_cidr "${1}"); then
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
function func_ipv4_form_cidr(){
	if ctype_ipv4_cidr $1; then
		echo "${1}" && true && return
	elif result=$(func_ipv4_netmask_to_cidr $1); then
		echo "${result}" && true && return
	fi
	false
}


#
# Egal ob  Netmask oder CIDR - immer CIDR ausgeben
# 255.0.0.0 => 255.0.0.0
# 8         => 255.0.0.0
#
function func_ipv4_form_netmask(){
	if ctype_ipv4_netmask $1; then
		echo "${1}" && true && return
	elif result=$(func_ipv4_cidr_to_netmask $1); then
		echo "${result}" && true && return
	fi
 	false
}


