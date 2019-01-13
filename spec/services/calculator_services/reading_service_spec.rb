require 'rails_helper'

RSpec.describe CalculatorServices::ReadingService, type: :service do
  let!(:thermostat) { create(:thermostat) }
  let(:post_worker) { ReadingWorkers::PostWorker.new }
  let(:delete_worker) { ReadingWorkers::DeleteWorker.new }

  before(:each) do
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
    unless Sneakers::Testing.messages_by_queue.empty?
      post_worker.work(Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:create]].first)
    end
  end

  describe 'first validation' do
    it 'has first message which was saved in db' do
      expect(::Reading.count).to eq(1)
    end

    it 'has first message contained in redis' do
      expect(RedisServices::ReadingPool.find_by(reading_id: @first_id)).to_not eq(nil)
    end

    it 'has first message which was deleted out from redis' do
      delete_worker.work(Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:delete]].first)
      expect(RedisServices::ReadingPool.find_by(reading_id: @first_id)).to eq(nil)
    end
  end

  describe '#average' do
    before(:each) do
      delete_worker.work(Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:delete]].first)
      request_attributes = ['temperature', 'humidity', 'battery_charge']
      @result = CalculatorServices::ReadingService.average(request_attributes,
                                                          thermostat_id: thermostat.id )
    end

    it 'returns 30 as the average of temperature' do
      expect(@result['temperature']).to eq(30)
    end

    it 'returns 40 as the average of humidity' do
      expect(@result['humidity']).to eq(40)
    end

    it 'returns 50 as the average of battery charge' do
      expect(@result['battery_charge']).to eq(50)
    end
  end
end