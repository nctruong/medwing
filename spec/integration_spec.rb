require 'rails_helper'

RSpec.describe 'integration' do
  include Helpers::Printer


  describe '#POST' do
    include_
    include_examples :expected_reading_order
  end
end