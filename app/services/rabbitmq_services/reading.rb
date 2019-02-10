module RabbitmqServices

  class Reading < Base

    OPTIONS = {
      channel: 'medwing',
      exchange: 'medwing.readings',
      delayed_exchange: {
        publisher: {
          connection: $bunny_conn ||= Bunny.new,
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
        RedisServices::ReadingPool.create(id, reading_attributes)
        id
      end

      def delete(id)
        p "id ================================================================= #{id}"
        Sneakers::Publisher.new(OPTIONS[:delayed_exchange][:publisher])
          .publish(id, headers: OPTIONS[:delayed_exchange][:headers], routing_key: OPTIONS[:queues][:delete]);
        p "published =========================================================="
      end

      def get(id)
        result = grab_result(id)
        block_given? ? yield(result) : RedisServices::Readings::DataType.string_to_json(result)
      end

      private

        def grab_result(id)
          # Benchmark.bm do |x|
          #   x.report do
          # byebug
          RedisServices::ReadingPool.find_by(reading_id: id) || ::Reading.find_by(id: id)
          #   end
          # end
          # result.to_json if result.present?
        end

        def publish_to_queue(reading_attributes)
          id = RedisServices::ReadingPool.nextId
          $post_queue.publish(
              reading_attributes.merge(id: id).to_json, routing_key: OPTIONS[:queues][:create]
          )
          RedisServices::ReadingPool.save_last_id(id)
          id
        end
    end
  end
end