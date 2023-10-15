# bigint vs uuid keyset pagination benchmarking

Batch approach is not done for uuids since you can't really pre-calculate all existing batches.

## Setup

```console
$ make up
$ make create
$ make bench
$ make bench-ruby
```

## Results

### In psql

```shell
$ make bench
Timing is on.
bigint batches:
DO
Time: 27911,536 ms (00:27,912)
bigint keyset:
DO
Time: 18464,831 ms (00:18,465)
uuid v4 keyset:
DO
Time: 40797,448 ms (00:40,797)
uuid v7 keyset:
DO
Time: 25438,581 ms (00:25,439)
uuid v4 insertion:
INSERT 0 10000000
Time: 231315,171 ms (03:51,315)
uuid v7 insertion:
INSERT 0 10000000
Time: 37850,565 ms (00:37,851)
```

### In Ruby (using Sequel)

```shell
$ make bench-ruby
bigint batches: 81.09633073300029 seconds
bigint keyset: 82.02242278300037 seconds
uuid v4 keyset: 98.97367430300073 seconds
uuid v7 keyset: 90.24869333099923 seconds
```
