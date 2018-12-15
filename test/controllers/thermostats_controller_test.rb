require 'test_helper'

class ThermostatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @thermostat = thermostats(:one)
  end

  test "should get index" do
    get thermostats_url, as: :json
    assert_response :success
  end

  test "should create thermostat" do
    assert_difference('Thermostat.count') do
      post thermostats_url, params: { thermostat: { household_token: @thermostat.household_token, location: @thermostat.location } }, as: :json
    end

    assert_response 201
  end

  test "should show thermostat" do
    get thermostat_url(@thermostat), as: :json
    assert_response :success
  end

  test "should update thermostat" do
    patch thermostat_url(@thermostat), params: { thermostat: { household_token: @thermostat.household_token, location: @thermostat.location } }, as: :json
    assert_response 200
  end

  test "should destroy thermostat" do
    assert_difference('Thermostat.count', -1) do
      delete thermostat_url(@thermostat), as: :json
    end

    assert_response 204
  end
end
