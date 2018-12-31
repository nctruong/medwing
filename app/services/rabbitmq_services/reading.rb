module RabbitmqServices

  class Reading < Base

    RABBITMQ_OPTIONS = {
      channel: 'medwing',
      exchange: 'medwing.readings',
      delayed_exchange: {
        # publisher: {
        #   exchange: 'delayed.exchange',
        #   exchange_options: {
        #     type: 'x-delayed-message',
        #     arguments: { 'x-delayed-type' => 'direct' },
        #     durable: true,
        #     auto_delete: false
        #   },
        # },
        headers: { 'x-delay': 1000 }
      },
      queues: {
        create: 'readings.create',
        delete: 'readings.delete'
      }
    }

    class << self

      def post(reading_attributes)
        publish_to_queue(reading_attributes)
      end

      def delete(id)
        # Sneakers::Publisher.new(RABBITMQ_OPTIONS[:delayed_exchange][:publisher])
        $delayed_exchange.publish(id,
                   headers: RABBITMQ_OPTIONS[:delayed_exchange][:headers], routing_key: RABBITMQ_OPTIONS[:queues][:delete]);
      end

      def get(id)
        grab_result(id)
      rescue Timeout::Error
        @rabbitmq_logger.info("READING") { "Reading##{id}: Timeout in #{TIMEOUT} seconds" }
      end

      private

        def grab_result(id)
          result = {}
          puts "-------------------------------------------------------------------"
          Benchmark.bm do |x|
            x.report do
              result = RedisServices::ReadingPool.get_result(id) || ::Reading.find_by(id: id)
            end
          end
          result
        end

        def get_id
          redis_id = Redis.current.get('readings.last_id')
          db_id = (::Reading.maximum(:id)&.next || 1)
          id = redis_id || db_id
          Redis.current.set('readings.last_id', id)
          id
        end

        def publish_to_queue(reading_attributes)
          id = RedisServices::ReadingPool.nextId
          # channel = $bunny_conn.create_channel
          $post_queue.publish(
              reading_attributes.merge(id: id).to_json, routing_key: RABBITMQ_OPTIONS[:queues][:create]
          )
          # channel.close
          RedisServices::ReadingPool.save_lastId(id)
          id
        end
    end
  end
end