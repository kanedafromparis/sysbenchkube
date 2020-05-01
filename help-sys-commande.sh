#!/bin/bash
#
# This is just a simple reminder
# 
#

echo "
### For CPU
sysbench cpu --cpu-max-prime=20 run 

### For memory
sysbench memory --threads=4 run

### For io
cd /bench/data &&\
 sysbench --test=fileio --file-total-size=10G prepare &&\
 sysbench --test=fileio --file-total-size=10G --file-test-mode=rndrw --time=300 --max-requests=0 run 
 # sysbench --test=fileio --file-total-size=10G --file-test-mode=rndrw --time=300 --max-requests=0 cleanup

### For postgres

sysbench --db-driver=pgsql --report-interval=2 \
  --oltp-table-size=100 --oltp-tables-count=20 \
  --threads=64 --time=60 \
  --pgsql-host=some-postgres \
  --pgsql-port=5432 \
  --pgsql-user=postgres \
  --pgsql-password=mysecretpassword \
  --pgsql-db=postgres \
  /usr/share/sysbench/tests/include/oltp_legacy/oltp.lua prepare &&\
  sysbench \
    --db-driver=pgsql \
    --report-interval=2 \
    --oltp-table-size=100 \
    --oltp-tables-count=20 \
    --threads=64 \
    --time=60 \
    --pgsql-host=some-postgres \
    --pgsql-port=5432 \
    --pgsql-user=postgres \
    --pgsql-password=mysecretpassword \
    --pgsql-db=postgres \
    /usr/share/sysbench/tests/include/oltp_legacy/oltp.lua \
  run
  # sysbench --db-driver=pgsql --report-interval=2 --oltp-table-size=100 --oltp-tables-count=20 --threads=64 --time=60 --pgsql-host=some-postgres --pgsql-port=5432 --pgsql-user=postgres --pgsql-password=mysecretpassword \
    --pgsql-db=postgres /usr/share/sysbench/tests/include/oltp_legacy/oltp.lua cleanup
"
