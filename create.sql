create or replace function uuid_generate_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
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

create table if not exists uuid_v4_then_v7 as table uuid_v4;

vacuum analyze bigint;
vacuum analyze uuid_v4;
vacuum analyze uuid_v4_then_v7;
vacuum analyze uuid_v7;
