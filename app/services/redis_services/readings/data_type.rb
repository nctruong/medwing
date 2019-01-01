module RedisServices::Readings
  module DataType
    def json_to_string(data)
    end

    def string_to_json(data)
      JSON.parse(data)
    end
  end
end