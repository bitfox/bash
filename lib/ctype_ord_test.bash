#!/bin/bash
#
# ctype_ord_test.bash
#
# Testscript für ctype_ord.bash
#
# 2023-06-22 22:37 CEST Oliver Lenz     Initial
#

. ./ctype_ord.bash
( for testfunction in 'ctype_natural' 'ctype_natural_and_zero' 'ctype_byte' 'ctype_word' 'ctype_longword' 'ctype_integer' 'ctype_shortint' 'ctype_smallint' 'ctype_realnum'; do
        for testdata in '' ' ' '-' '+' '-2147483648' '-32768' '-128' '-0' '+0' '01' '-1' '-1.0' '0' '1' '2' '+1' '-1.0' '+1.0' '1.0' '127' '128' '255' '256' '32767' '32768' '65535' '65536' '2147483647' '2147483648' '4294967295' '4294967296'; do
                printf "Testing %-20s %15s => " "${testfunction}" "${testdata}"
                if ${testfunction} ${testdata}; then
                        echo "TRUE"
                else
                        echo "FALSE"
                fi

        done
done ) | tee ctype_ord_test.txt
