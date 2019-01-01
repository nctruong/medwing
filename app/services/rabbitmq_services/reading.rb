module RabbitmqServices

  class Reading < Base

    OPTIONS = {
      channel: 'medwing',
      exchange: 'medwing.readings',
      delayed_exchange: {
        publisher: {
          connection: $bunny_conn,
          exchange: 'delayed.exchange',
          exchange_options: {
            type: 'x-delayed-message',
            arguments: { 'x-delayed-type' => 'direct' },
            durable: true,
            auto_delete: false
          },
        },
        headers: { 'x-delay': 1000 }
      },
      queues: {
        create: 'readings.create',
        delete: 'readings.delete'
      }
    }

    class << self

      def post(reading_attributes)
        id = publish_to_queue(reading_attributes)
        RedisServices::ReadingPool.set_result(id, reading_attributes)
        id
      end

      def delete(id)
        Sneakers::Publisher.new(OPTIONS[:delayed_exchange][:publisher])
          .publish(id, headers: OPTIONS[:delayed_exchange][:headers], routing_key: OPTIONS[:queues][:delete]);
      end

      def get(id)
        result = grab_result(id)
        block_given? ? yield(result) : result
      end

      private

        def grab_result(id)
          # Benchmark.bm do |x|
          #   x.report do
          # byebug
          RedisServices::ReadingPool.get_result(id) || ::Reading.find_by(id: id)
          #   end
          # end
          # result.to_json if result.present?
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
              reading_attributes.merge(id: id).to_json, routing_key: OPTIONS[:queues][:create]
          )
          # channel.close
          RedisServices::ReadingPool.save_lastId(id)
          id
        end
    end
  end
end