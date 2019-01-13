module CalculatorServices
  class ReadingService
    class << self
      def average(attributes, opts = {})
        avg = {}
        db_avg = average_from_db(attributes, opts)
        pending_avg = average_from_pending_jobs(attributes, opts[:thermostat_id])

        attributes.each do |attr|
          avg[attr] = ((db_avg[attr] || 0) + (pending_avg[attr] || 0)) / 2
        end
        avg
      end

      private

      def average_from_db(attributes, opts = {})
        if opts[:thermostat_id] && Thermostat.find_by(id: opts[:thermostat_id]).nil?
          Rails.logger.debug { "Thermostat id##{opts[:thermostat_id]} not found" }
        end
        ReadingQueries::Average.get(attributes,
            opts[:thermostat_id] ? "thermostat_id = #{opts[:thermostat_id]}" : '')
      end

      def average_from_pending_jobs(attributes, thermostat_id)
        avg = {}
        readings = RedisServices::ReadingPool.where(thermostat_id: thermostat_id)

        readings.replace(readings.collect { |reading| RedisServices::Readings::DataType.string_to_json(reading) })
        count = readings&.size
        unless readings.blank?
          attributes.each do |attr|
            sum = 0
            readings.each { |reading| sum += reading[attr]&.to_i || 0 }
            avg[attr] = sum / count
          end
        end
        avg
      end
    end
  end
end