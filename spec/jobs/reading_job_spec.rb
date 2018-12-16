require 'spec/rails_helper'

RSpec.describe ReadingJob, type: :job do
  describe 'valid' do
    it 'enqueues another job in ReadingQueue after success'
  end

  describe 'valid' do
    it 'enqueues another job in ReadingQueue after failure'
  end
end