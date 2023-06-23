#!/bin/bash
#
# func_ipv4_test.bash
#
# Testscript für func_ipv4.bash
#
# 2023-06-23 18:37 CEST	Oliver Lenz	Initial
# 2023-06-23 20:57 CEST Oliver Lenz     Generalisieren der Testlogik.
#


testfile="../func_ipv4.bash"
. ./${testfile}


testdataset=(
	' ' '-1' '0' '1' '32' '33' 
	'172.0.0.1' 'localhost' 'localhost.local' 
	'10.0.0.0' '10.0.0.1' '010.0.0.1' '192.168.0.0' '192.168.0.1' '255.128.0.0' 
	'3232235521' '255.255.255.255'
)

(
	while read line; do 
		[[ $line =~ ^[\ \t]*(function\ |)([a-zA-Z0-9_]+)\( ]] && testfunction="${BASH_REMATCH[2]}"
		for testdata in "${testdataset[@]}"; do
			printf "Testing %-25s %20s => " "${testfunction}" "${testdata}"
			if result=$( ${testfunction} ${testdata} ); then
				functional="TRUE"
			else
				functional="FALSE"
			fi
			printf "%-6s %s\n" "${functional}" "${result}"
		done
	done< <(grep -E "^[ \t]*(|function )([a-zA-Z0-9_]+)\(" "${testfile}")

) 2>&1 | tee "${0%%.bash}.txt"
