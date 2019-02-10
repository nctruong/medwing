module RedisServices::Readings
  module Average
    def set_average(val)
      Redis.current.set(options[:average], val)
    end

    def average
      Redis.current.get(options[:average])
    end
  end
end