# sysbenchkube

## How to testing

### on my local docker

0. optionnal :

0.1. create docker machine
```bash
docker-machine create sysbench
eval $(docker-machine env sysbench)
```

0.2 create local volume

```bash
docker volume create bench
docker volume create pgdata
```

0.3 create local network

```bash
docker create network some-network
```

0.4 start local posgresql

```bash
docker run --name some-postgres --rm \
   --cpu-shares=512 --memory=512M \
   --mount source=pgdata,target=/var/lib/postgresql/data \
   --network some-network \
    -e POSTGRES_PASSWORD=mysecretpassword \
   -d postgres:12
```

if needed 
```bash
docker run -it --rm --network some-network postgres:12 psql -h some-postgres -U postgres
```

1. run io test

```bash
docker run -it --cpu-shares=512 --memory 512M --mount source=bench,target=/bench/data sysbench /bin/bash
# into the container
cd /bench/data &&\
 sysbench --test=fileio --file-total-size=10G prepare &&\
 sysbench --test=fileio --file-total-size=10G --file-test-mode=rndrw --time=300 --max-requests=0 run
 # sysbench --test=fileio --file-total-size=10G --file-test-mode=rndrw --time=300 --max-requests=0 cleanup

```

2. run posgresql test

```bash
docker run -it --cpu-shares=512 --memory 512M --network some-network sysbench /bin/bash
# into the container

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
``` 


### on my kubenetess cluster

<!-- todo operator -->

## How to build 

Just a simple build

```bash
docker build . -t sysbench
```

## Ressources
 - https://github.com/akopytov/sysbench
 - https://hub.docker.com/_/postgres
 - 
