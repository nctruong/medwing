module RedisServices
  class ReadingPool
    class << self
      include RedisServices::Readings::Queries
      include RedisServices::Readings::IdStorage
      include RedisServices::Readings::LookingKey

      # key: array of ids system is looking for
      # value: find by above ids
      # lastId: to determine next id for POST
      # pattern: for saving above key
      def options
        {
          key: 'readings.look4ids',
          value: 'readings.',
          lastId: 'readings.last_id',
          pattern: ','
        }
      end

      private

      def result_key(reading_id, thermostat_id)
        "#{options[:value]}#{reading_id}#{thermostat_id.present? ? ('-' << thermostat_id.to_s) : ''}"
      end
    end
  end
end
