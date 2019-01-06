require 'rails_helper'

RSpec.describe CalculatorServices::ReadingService, type: :service do
  describe '#average' do
    it 'returns exact the average of temperature'
    it 'returns exact the average of humidity'
    it 'returns exact the average of battery charge'

    context 'all data saved already in database - Postgres' do
      it 'returns exact the average of temperature'
      it 'returns exact the average of humidity'
      it 'returns exact the average of battery charge'
    end

    context 'all data stored temporary in RAM - Redis' do
      it 'returns exact the average of temperature'
      it 'returns exact the average of humidity'
      it 'returns exact the average of battery charge'
    end

    context 'a part of data stored temporary in RAM - Redis' do
      it 'returns exact the average of temperature'
      it 'returns exact the average of humidity'
      it 'returns exact the average of battery charge'
    end
  end
end