module ApiServices
  class ReadingService < Base
    def post(reading_params)
      self.class.post("/readings", get_params({ readings: reading_params }))
    end

    def get(id)
      self.class.get("/readings/#{id}", options).body
    end

    private

    def get_params(params_json)
      { query: params_json}
    end
  end
end