module RedisServices::Readings
  module LookingKey
    def id_exists?(id)
      ids.present? && ids.include?(id.to_s)
    end

    def remove(id)
      val = ids
      val.delete(id.to_s)
      Redis.current.set(options[:key], val.join(options[:pattern]))
      Redis.current.del(result_key(id))
    end

    def add(id)
      Redis.current.set(options[:key], (ids&.uniq || []).push(id).join(options[:pattern]))
    end

    def ids
      Redis.current.get(options[:key])&.split(options[:pattern])
    end
  end
end