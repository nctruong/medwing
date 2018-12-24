class ApplicationController < ActionController::API
  HTTP_STATUS = {
      success: 200,
      bad_request: 400,
      not_found: 404
  }

  private

  def render_json(json, status = HTTP_STATUS[:success])
    render json: json, status: status
  end
end
