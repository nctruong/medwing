class Thermostat < ApplicationRecord
  has_many :readings

  has_secure_token :household_token

  validates :location, presence: true
end
