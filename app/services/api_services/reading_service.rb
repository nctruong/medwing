module ApiServices
  class ReadingService < Base
    def post(reading_params)
      self.class.post("/readings", get_params(reading_params))
    end

    private

    def get_params(reading_params, extra_params = {})
      { query: {readings: reading_params }} #.merge(extra_params)
    end
  end
end