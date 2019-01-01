module RedisServices::Readings
  module DataType
    def self.json_to_string(data)
      data.to_s
    end

    def self.string_to_json(data)
      JSON.parse(data&.gsub('=>',':'))
    end
  end
end