module RedisServices::Readings
  module Result
    def get_result(id)
      Redis.current.get(result_key(id))
    end

    def set_result(id, result)
      Redis.current.set(result_key(id), result)
    end
  end
end