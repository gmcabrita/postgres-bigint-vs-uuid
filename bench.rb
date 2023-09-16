require "sequel"
require "benchmark"

DB = Sequel.connect("postgres://postgres:@localhost")

# require "logger"
# DB.loggers << Logger.new($stdout)

bench_bigint_batches = Benchmark.measure {
  start_id = 0
  loop do
    start_id = DB[:bigint].select(:id).where{(id > start_id) & (id <= start_id + 500)}.all.last&.[](:id)
    break if start_id.nil?
  end
}
puts "bigint batches: #{bench_bigint_batches.real} seconds"

bench_bigint_keyset = Benchmark.measure {
  next_id = 0
  loop do
    next_id = DB[:bigint].select(:id).where{id > next_id}.order{id.asc}.limit(500).all.last&.[](:id)
    break if next_id.nil?
  end
}
puts "bigint keyset: #{bench_bigint_keyset.real} seconds"

bench_uuid_v4_keyset = Benchmark.measure {
  next_id = nil
  loop do
    next_id = if next_id
      DB[:uuid_v4].select(:id).where{id > next_id}.order{id.asc}.limit(500).all.last&.[](:id)
    else
      DB[:uuid_v4].select(:id).order{id.asc}.limit(500).all.last&.[](:id)
    end
    break if next_id.nil?
  end
}
puts "uuid v4 keyset: #{bench_uuid_v4_keyset.real} seconds"

bench_uuid_v7_keyset = Benchmark.measure {
  next_id = nil
  loop do
    next_id = if next_id
      DB[:uuid_v7].select(:id).where{id > next_id}.order{id.asc}.limit(500).all.last&.[](:id)
    else
      DB[:uuid_v7].select(:id).order{id.asc}.limit(500).all.last&.[](:id)
    end
    break if next_id.nil?
  end
}
puts "uuid v7 keyset: #{bench_uuid_v7_keyset.real} seconds"

