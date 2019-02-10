module Support
  module Contexts
    module ReadingParams
      RSpec.shared_context :reading_params do
        let(:thermostat) { create(:thermostat) }
        let(:reading_params) {
          attributes_for(:reading).merge(thermostat_id: thermostat.id)
        }
      end

      RSpec.shared_context :testing_data do
        def create_sample_data(options = {})
          thermostats = []
          (options[:thermostat_quantity] || 10).times { thermostats << FactoryBot.create(:thermostat) }
          (options[:reading_quantity] || 100).times {
            RabbitmqServices::Reading.post(reading_params.merge(thermostat_id: thermostats.sample.id))
          }
        end

        def create_data_for_average(thermostat)
          @first_id = RabbitmqServices::Reading.post({
                                                         temperature: 32,
                                                         humidity: 38,
                                                         battery_charge: 80,
                                                         thermostat_id: thermostat.id
                                                     })
          @second_id = RabbitmqServices::Reading.post({
                                                          temperature: 28,
                                                          humidity: 42,
                                                          battery_charge: 20,
                                                          thermostat_id: thermostat.id
                                                      })
        end
      end
    end
  end
end