up:
	docker compose up -d

down:
	docker compose down

psql:
	psql --username=postgres --host=localhost

setup:
	psql --username=postgres  --host=localhost -f create.sql

bench:
	psql --username=postgres  --host=localhost -f bench.sql

bench-ruby:
	gem install sequel
	ruby bench.rb
