#!/bin/bash
source ../func_datetime.bash

(
wodowim "2031-07-31" # der wie oft wiederholte wochentag war das?
# 2031-07 5 4   # der 5. Donnerstag im Juli 2031
get_dfdowiwom "2031-07" 5 4 # welches Datum ist der 5te  Donnerstag im Juli 2031
# 2031-07-31    # der 31.07.2031
) > func_datetime_test.txt
