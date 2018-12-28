module RedisServices
  class ReadingPool
    class << self
      include RedisServices::Readings::Result
      include RedisServices::Readings::IdStorage
      include RedisServices::Readings::LookingKey

      # key: array of ids system is looking for
      # value: find by above ids
      # lastId: to determine next id for POST
      # pattern: for saving above key
      def options
        {
          key: 'readings.look4ids',
          value: 'readings.result-',
          lastId: 'readings.last_id',
          pattern: ','
        }
      end

      private

      def result_key(id)
        options[:value] << id.to_s
      end
    end
  end
end
