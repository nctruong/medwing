module RedisServices::Readings
  module IdStorage
    def nextId
      (Redis.current.get(options[:lastId]) || (::Reading.maximum(:id) || 0)).to_i + 1
    end

    def save_last_id(id)
      Redis.current.set(options[:lastId], id)
    end

    def last_id
      Redis.current.get(options[:lastId])
    end
  end
end