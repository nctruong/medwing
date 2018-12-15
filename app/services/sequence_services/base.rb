module SequenceServices
  class Base
    attr_reader :key

    def initialize(options = {})
      @key = options[:key] || 'seq-key'
    end

    def set(val)
      Redis.current.set(key, val)
      val
    end

    def get
      Redis.current.get(key)
    end
  end
end