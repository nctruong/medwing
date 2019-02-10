require 'rails_helper'

RSpec.describe StatsController, type: :controller do
  let!(:thermostat) { create(:thermostat) }
  let(:params) { { thermostat_id: thermostat.id } }

  include_context :testing_data

  describe '#GET' do
    before(:each) do
      create_data_for_average(thermostat)
      get :average, params: params
      @result = JSON.parse(response.body)
    end

    include_examples :expected_average
  end
end