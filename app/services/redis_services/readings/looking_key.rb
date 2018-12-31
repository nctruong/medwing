module RedisServices::Readings
  module LookingKey
    def remove(id)
      Redis.current.del(result_key(id))
    end
  end
end