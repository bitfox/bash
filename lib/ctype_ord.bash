#!/bin/bash
#
# ctype_num.bash
#
# Numerische Testtypen in Bash
#
# 2023-06-22 22:39 CEST  Oliver Lenz    Initial
#



#
# Gibt eine gesäuberte Zahl zurück:
# unnötiges positives Vorzeichen, führende nullen, nachfolgende nullen
# und überflüssige komma werden entfernt
#
# +00.100 == 0.1
#
function clean_value(){
        if [[ ${1} =~ ^([+-]{0,1})([0-9]+)(|\.[0-9]*)$ ]]; then
                (( a=${1}+0 ))
                (( a == $1 )) && echo $a && true
        fi
        false
}

#
# Natürliche Zahlen ohne 0 ohne Vorzeichen
# 1, 2, 3 ...
#
function ctype_natural(){
        [[ "${1:0:1}" != "0" && "${1}" =~ ^([0-9]+)$ && "${BASH_REMATCH[1]}" == "${1}" ]] && true || false
}

#
# Natürliche Zahlen mit 0 ohne Vorzeichen
# 0, 1, 2, ...
#
function ctype_natural_and_zero(){
        [[ "${1}" == "0" || "${1:0:1}" != "0" && "${1}" =~ ^([0-9]+)$ && "${BASH_REMATCH[1]}" == "${1}" ]] && true || false
}

#
# Natürliche Zahlen von 0 bis 255 ohne Vorzeichen
# 0, 1, 2, ... 255
#
function ctype_byte(){
        ctype_natural_and_zero "${1}" && [ ${1} -le 255 ] && true || false
}

#
# Natürliche Zahlen von 0 bis 65535 ohne Vorzeichen
# 0, 1, 2, ...65535
#
function ctype_word(){
        ctype_natural_and_zero "${1}" && [ ${1} -le 65535 ] && true || false
}

#
# Natürliche Zahlen von 0 bis 4294967295 ohne Vorzeichen
# 0, 1, 2, ... 4294967295
#
function ctype_longword(){
        ctype_natural_and_zero "${1}" && [ ${1} -le 4294967295 ] && true || false
}
function ctype_cardinal(){
        ctype_longword ${1} && true || false
}

#
# Natürliche Zahlen inkl. negativem Vorzeichen
# von -2147483648 .. 2147483647
#
#
function ctype_integer(){
        [[ "${1}" == "0" || "${1:0:1}" != "0" && "${1}" =~ ^(-|)([0-9]+)$ && "${BASH_REMATCH[0]}" == "${1}" && ${1} -ge -2147483648 && ${1} -le 2147483647 ]] && true || false
}
function ctype_longint(){
        ctype_integer ${1} && true || false
}

#
# Natürliche Zahlen inkl. negativem Vorzeichen
# von -128 .. 127
#
function ctype_shortint(){
        [[ "${1}" == "0" || "${1:0:1}" != "0" && "${1}" =~ ^(-|)([0-9]+)$ && "${BASH_REMATCH[0]}" == "${1}" && ${1} -ge -128 && ${1} -le 127 ]] && true || false
}

#
# Natürliche Zahlen inkl. negativem Vorzeichen
# von -32768 .. 32767
#
function ctype_smallint(){
        [[ "${1}" == "0" || "${1:0:1}" != "0" && "${1}" =~ ^(-|)([0-9]+)$ && "${BASH_REMATCH[0]}" == "${1}" && ${1} -ge -32768 && ${1} -le 32767 ]] && true || false
}

#
# Reelle Zahlen
# z.B. -1.234 .. 0 .. 1.234
#
function ctype_realnum(){
        [[ "${1}" == "0" || "${1:0:1}" != "0" && "${1}" =~ ^(-|)([0-9]+)(|\.[0-9]+)$ && "${BASH_REMATCH[0]}" == "${1}" ]] && true || false
}
