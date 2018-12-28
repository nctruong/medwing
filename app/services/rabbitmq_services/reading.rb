module RabbitmqServices

  class Reading < Base
    TIMEOUT = 1
    RABBITMQ_OPTIONS = {
      channel: 'medwing',
      exchange: 'medwing.readings',
      queues: {
        create: 'readings.create'
      }
    }

    class << self

      def post(reading_attributes)
        publish_to_queue(reading_attributes)
      end

      def get(id)
        set_looking_id(id)
        grab_result(id)
      rescue Timeout::Error
        @rabbitmq_logger.info("READING") { "Reading##{id}: Timeout in #{TIMEOUT} seconds" }
      end

      private

        def set_looking_id(id)
          RedisServices::ReadingPool.add(id)
        end

        def grab_result(id)
          result = {}
          Timeout.timeout(TIMEOUT) do
            until result.present? do
              result = ::Reading.find_by(id: id)
              result ||= RedisServices::ReadingPool.get_result(id)
            end
          end
          yield(result) if block_given?
          result
        end

        def get_id
          redis_id = Redis.current.get('readings.last_id')
          db_id = (::Reading.maximum(:id)&.next || 1)
          id = redis_id || db_id
          Redis.current.set('readings.last_id', id)
          id
        end

        def open_connection
          connection = Bunny.new
          connection.start
          channel = connection.create_channel
          yield(channel) if block_given?
          connection.close
        end

        def publish_to_queue(reading_attributes)
          id = RedisServices::ReadingPool.nextId
          open_connection do |channel|
            channel.exchange(RABBITMQ_OPTIONS[:exchange], { durable: true }).publish(
                reading_attributes.merge(id: id).to_json, routing_key: RABBITMQ_OPTIONS[:queues][:create]
            )
            RedisServices::ReadingPool.save_lastId(id)
          end
          id
        end
    end
  end
end