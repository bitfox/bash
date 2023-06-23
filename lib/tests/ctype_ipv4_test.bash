#!/bin/bash
#
# ctype_ord_test.bash
#
# Testscript für ctype_ipv4.bash
#
# 2023-06-22 22:37 CEST	Oliver Lenz	Initial
#

. ./ctype_ipv4.bash
( for testfunction in 'ctype_ipv4_cidr' 'ctype_ipv4_address' 'ctype_ipv4_netmask'; do
	for testdata in '' ' ' '-1' '0' '1' '32' '33' '10.0.0.0' '10.0.0.1' '010.0.0.1' '192.168.0.0' '192.168.0.1' '255.128.0.0'; do
		printf "Testing %-20s %15s => " "${testfunction}" "${testdata}"
		if ${testfunction} ${testdata}; then
			echo "TRUE"
		else
			echo "FALSE"
		fi

	done
done ) | tee ctype_ipv4_test.txt
