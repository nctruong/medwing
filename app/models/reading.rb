class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :number, presence: true
  validates :temperature, presence: true
  validates :humidity, presence: true
  validates :battery_charge, presence: true

  before_validation :update_seq

  # retrieve in queue for consistent data
  # making sure seq is always updated before saving
  def update_seq
    if self.thermostat.present?
      seq_token = SequenceServices::SeqToken.new(household_token: self.thermostat.household_token)
      self.number = seq_token.get.nil? ? seq_token.set(1) : (seq_token.get + 1)
      seq_token.set(self.number.to_s)
    else
      raise Exception, "Thermostat with id #{self.try(:thermostat_id)} not found"
    end
  end
end
