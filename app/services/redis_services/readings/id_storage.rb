module RedisServices::Readings
  module IdStorage
    def nextId
      (Redis.current.get(options[:lastId]) || (::Reading.maximum(:id) || 0)).to_i + 1
    end

    def save_lastId(id)
      Redis.current.set(options[:lastId], id)
    end
  end
end