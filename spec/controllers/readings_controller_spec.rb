require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  include_context :reading_params

  describe '#POST' do
    context 'valid household token' do
      it 'creates successfully' do
        post :create, params: { reading: reading_params }
        expect(response.status).to eq(200)
      end
    end

    context 'invalid thermostat id' do
      it 'returns unsuccessful status due to not found thermostat id' do
        post :create, params: { reading: reading_params.merge(thermostat_id: 1000) }
        expect(response.status).to eq(400)
      end

      it 'returns unsuccessful status due to lacking of thermostat id' do
        post :create, params: { reading: reading_params.delete(:thermostat_id) }
        expect(response.status).to eq(400)
      end
    end
  end

  describe '#GET' do
    context 'invalid id' do
      before(:each) { get :show, params: { id: 1000 } }

      it 'returns unsuccessful status due to id not exists' do
        expect(response.status).to eq(404)
      end

      it 'returns unsuccessful status due to id not exists' do
        expect(JSON.parse(response.body, symbolize_names: true)[:message]).to include('not found')
      end
    end
  end
end