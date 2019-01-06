require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  let(:thermostat) { create(:thermostat) }
  let(:reading_params) {
    attributes_for(:reading).merge(thermostat_id: thermostat.id)
  }
  describe '#POST' do
    context 'valid household token' do
      it 'creates successfully' do
        post :create, params: { reading: reading_params }
        expect(response.status).to eq(200)
      end

      it 'stores enough temperature, humidity and battery charge'
      it 'generates correct sequence number'
    end

    context 'invalid household token' do
      it 'returns unsuccessful status due to wrong token' do

      end

      it 'returns unsuccessful status due to lacking of token' do

      end
    end
  end

  describe '#GET' do
    context 'valid household token' do
      it 'returns same info after posting'
    end

    context 'invalid household token' do
      it 'returns not found status'
    end
  end
end