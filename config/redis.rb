require 'redis'

Redis.current = Redis::Namespace.new("api", :redis => Redis.new)