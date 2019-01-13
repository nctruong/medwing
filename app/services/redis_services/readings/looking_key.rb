module RedisServices::Readings
  module LookingKey
    def remove(id)
      Redis.current.keys(result_key(id)).each { |key| Redis.current.del(key) }
    end
  end
end