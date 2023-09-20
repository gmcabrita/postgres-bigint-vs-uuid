create or replace function uuid_generate_v7()
returns uuid
as $$
declare
  unix_ts_ms bytea;
  uuid_bytes bytea;
begin
  unix_ts_ms = substring(int8send((extract(epoch from clock_timestamp()) * 1000)::bigint) from 3);

  -- use random v4 uuid as starting point (which has the same variant we need)
  uuid_bytes = uuid_send(gen_random_uuid());

  -- overlay timestamp
  uuid_bytes = overlay(uuid_bytes placing unix_ts_ms from 1 for 6);

  -- set version 7 by flipping the 2 and 1 bit in the version 4 string
  uuid_bytes = set_bit(set_bit(uuid_bytes, 53, 1), 52, 1);

  return encode(uuid_bytes, 'hex')::uuid;
end
$$
language plpgsql
volatile;

drop table if exists bigint;
drop table if exists uuid_v4;
drop table if exists uuid_v7;

create table if not exists bigint (id bigint primary key not null);
create table if not exists uuid_v4 (id uuid primary key not null);
create table if not exists uuid_v7 (id uuid primary key not null);

insert into bigint (id) select * from generate_series(1, 100_000_000);
insert into uuid_v4 (id) select gen_random_uuid() from generate_series(1, 100_000_000);
insert into uuid_v7 (id) select uuid_generate_v7() from generate_series(1, 100_000_000);

vacuum analyze bigint;
vacuum analyze uuid_v4;
vacuum analyze uuid_v7;
