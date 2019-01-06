module ApiServices
  class StatService < Base
    def get(id)
      self.class.get("/stats", get_params({ thermostat_id: id })).body
    end

    private

    def get_params(params_json)
      { query: params_json}
    end
  end
end