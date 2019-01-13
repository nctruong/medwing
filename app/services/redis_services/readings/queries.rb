module RedisServices::Readings
  module Queries
    # Find by reading_id
    def find_by(opts = {})
      if opts[:reading_id].present? && opts[:thermostat_id].present?
        Redis.current.get(result_key(opts[:reading_id], opts[:thermostat_id]))
      elsif opts[:reading_id].present?
        key = Redis.current.keys("readings.#{opts[:reading_id]}-*").first
        Redis.current.get(key)
      else
        raise "Require at least reading_id"
      end
    end

    # Find by thermostat_id, returns an array
    def where(opts = {})
      if opts[:thermostat_id].present?
        keys = Redis.current.keys("readings.*-#{opts[:thermostat_id]}")
        keys.collect { |key| Redis.current.get(key) }
      else
        raise "Only allow to query by thermostat id"
      end
    end

    def create(reading_id, result)
      # byebug
      raise "Thermostat id can't be nil" unless result[:thermostat_id].present?
      Redis.current.set(result_key(reading_id, result[:thermostat_id]), result)
    end
  end
end