require 'rails_helper'

RSpec.describe CalculatorServices::ReadingService, type: :service do
  let!(:thermostat) { create(:thermostat) }
  let(:post_worker) { ReadingWorkers::PostWorker.new }
  let(:delete_worker) { ReadingWorkers::DeleteWorker.new }

  include_context :testing_data

  before(:each) do
    create_data_for_average(thermostat)
    unless Sneakers::Testing.messages_by_queue.empty?
      post_worker.work(Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:create]].first)
    end
  end

  describe 'validation' do
    it 'has first message which was saved in db' do
      expect(::Reading.count).to eq(1)
    end

    it 'has first message contained in redis' do
      expect(RedisServices::ReadingPool.find_by(reading_id: @first_id)).to_not eq(nil)
    end

    it 'has first message which was deleted out from redis after it saved' do
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

    include_examples :expected_average
  end
end