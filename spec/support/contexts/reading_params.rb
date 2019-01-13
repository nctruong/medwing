module Support
  module Contexts
    module ReadingParams
      RSpec.shared_context :reading_params do
        let(:thermostat) { create(:thermostat) }
        let(:reading_params) {
          attributes_for(:reading).merge(thermostat_id: thermostat.id)
        }
      end

      RSpec.shared_context :worker_data do
        def create_sample_data(options = {})
          thermostats = []
          (options[:thermostat_quantity] || 10).times { thermostats << FactoryBot.create(:thermostat) }
          (options[:reading_quantity] || 100).times {
            RabbitmqServices::Reading.post(reading_params.merge(thermostat_id: thermostats.sample.id))
          }
        end
      end
    end
  end
end