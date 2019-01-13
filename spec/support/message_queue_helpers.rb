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

module FakeBunny
  def self.publish(payload, opts)
    Sneakers::Testing.push(opts[:routing_key], payload)
  end
end

module Sneakers
  class Publisher
    def initialize(options = {}); end
    def publish(payload, opts)
      Sneakers::Testing.push(opts[:routing_key], payload)
    end
  end


end
$post_queue = FakeBunny

RSpec.configure do |config|
  config.include Sneakers::Testing

  config.before(:each) do
    Sneakers::Testing.clear_all
  end
end