module Sneakers
  module Testing
    class << self
      def all
        messages_by_queue.values.flatten
      end
      def [](queue)
        messages_by_queue[queue]
      end

      def push(queue, message)
        messages_by_queue[queue] << message
      end

      def messages_by_queue
        @messages_by_queue ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def clear_for(queue, klass)
        messages_by_queue[queue].clear
      end

      def clear_all
        messages_by_queue.clear
      end

    end
  end
end


module WorkerAdditions
  def publish(payload, opts)
    Sneakers::Testing.push(opts[:to_queue], payload)
  end
end


module QueuePublisher
  extend self
  def publish(payload, routing)
    Sneakers::Testing.push(routing[:to_queue], payload)
  end
end


RSpec.configure do |config|
  config.include WorkerAdditions
  config.include QueuePublisher
  config.include Sneakers::Testing

  config.before(:each) do
    Sneakers::Testing.clear_all
  end
end