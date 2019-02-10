require 'rails_helper'

RSpec.describe ReadingWorkers::DeleteWorker, type: :worker do
  include_context :reading_params
  include_context :testing_data

  let(:delete_worker) { ReadingWorkers::DeleteWorker.new }

  describe 'valid' do
    before(:each) do
      create_sample_data(thermostat_quantity: 20, reading_quantity: 100)
      Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:create]].each_with_index do |message, idx|
        ReadingWorkers::PostWorker.new.work(message)
      end
    end

    it 'finds 100 ids in queue' do
      expect(Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:delete]].count).to eq(100)
    end

    it 'deletes successfully key-value in redis' do
      Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:delete]].each_with_index do |message, idx|
        delete_worker.work(message)
        expect(RedisServices::ReadingPool.find_by(reading_id: message)).to eq(nil)
      end
    end
  end

  describe 'invalid' do
    it 'will not returns ack' do
      message = { id: 'invalid' }
      delete_worker.work(message)
      expect(delete_worker.work(message)).to_not eq(:ack)
    end

    it 'stores error message' do
      message = { id: 'invalid' }
      delete_worker.work(message)
      expect(WorkerMessage.count).to eq(1)
    end
  end
end