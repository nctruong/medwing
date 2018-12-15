module SequenceServices
  class SeqToken < Base
    def initialize(options = {})
      key = options[:household_token] || 'household_token'
      super(key: key)
    end

    def set(val)
      super(val).to_i
    end

    def get
      super.to_i
    end
  end
end