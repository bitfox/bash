#!/bin/bash
#
# ctype_ord_test.bash
#
# Testscript für ctype_ord.bash
#
# 2023-06-22 22:37 CEST	Oliver Lenz	Initial
# 2023-06-23 20:57 CEST Oliver Lenz     Generalisieren der Testlogik.
#

testfile="../ctype_ord.bash"
. ./${testfile}


testdataset=(
	'' ' ' '-' '+' '-2147483648' '-32768' '-128' '-0' '+0' '01' '-1' '-01' '-1.0' 
	'0' '1' '2' '+1' '-1.0' '+1.0' '1.0' 
	'127' '128' '255' '256' '32767' '32768' '65535' '65536' '2147483647' '2147483648' '4294967295' '4294967296'
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

) 2>&1  | tee "${0%%.bash}.txt"
