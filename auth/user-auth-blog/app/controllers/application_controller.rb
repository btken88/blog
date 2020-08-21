# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authorize
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ')[1]
    if !token
      render json: { error: 'Authorization failed' }
      
    else
      secret = Rails.application.secret_key_base
      payload = JWT.decode(token, secret)[0]
      @user = User.find(payload['user_id'])

      render json: { error: 'Authorization failed' } unless @user
    end
  end
end
