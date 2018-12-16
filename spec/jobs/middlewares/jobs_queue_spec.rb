require 'spec/rails_helper'

RSpec.describe Middleware::JobsQueue, type: :job do
  describe 'valid' do
    it 'enqueues successfully'
    it 'dequeues successfully'
    it 'only pushes one job into sidekiq queue'

  end
end