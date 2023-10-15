\timing

\! echo "bigint batches:"
do $$
declare
  start_id bigint := 0;
begin
  while start_id is not null loop
    select a[array_upper(a, 1)]
    into start_id
    from (
      select ARRAY(
        select id
        from bigint
        where id > start_id and id <= start_id + 500
      ) as a
    );
  end loop;
end$$;

\! echo "bigint keyset:"
do $$
declare
  keyset bigint := 0;
begin
  while keyset is not null loop
    select a[array_upper(a, 1)]
    into keyset
    from (
      select ARRAY(
        select id
        from bigint
        where id > keyset
        order by id asc
        limit 500
      ) as a
    );
  end loop;
end$$;


\! echo "uuid v4 keyset:"
do $$
declare
  keyset uuid;
begin
  select id
  into keyset
  from (select id from uuid_v4 order by id asc limit 1);

  while keyset is not null loop
    select a[array_upper(a, 1)]
    into keyset
    from (
      select ARRAY(
        select id
        from uuid_v4
        where id > keyset
        order by id asc
        limit 500
      ) as a
    );
  end loop;
end$$;

\! echo "uuid v7 keyset:"
do $$
declare
  keyset uuid;
begin
  select id
  into keyset
  from (select id from uuid_v7 order by id asc limit 1);

  while keyset is not null loop
    select a[array_upper(a, 1)]
    into keyset
    from (
      select ARRAY(
        select id
        from uuid_v7
        where id > keyset
        order by id asc
        limit 500
      ) as a
    );
  end loop;
end$$;

\! echo "uuid v4 insertion"
insert into uuid_v4 (id) select gen_random_uuid() from generate_series(1, 10_000_000);

\! echo "uuid v7 insertion"
insert into uuid_v4_then_v7 (id) select uuid_generate_v7() from generate_series(1, 10_000_000);
