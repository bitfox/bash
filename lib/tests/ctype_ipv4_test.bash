#!/bin/bash
#
# ctype_ord_test.bash
#
# Testscript für ctype_ipv4.bash
#
# 2023-06-22 22:37 CEST	Oliver Lenz	Initial
# 2023-06-23 20:57 CEST	Oliver Lenz	Generalisieren der Testlogik.
#

testfile="../ctype_ipv4.bash"
. ./${testfile}


testdataset=(
	'' ' ' '-1' '0' '1' '32' '33' '10.0.0.0' '10.0.0.1' '010.0.0.1' '192.168.0.0' '192.168.0.1' '255.128.0.0'
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
