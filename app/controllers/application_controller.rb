class ApplicationController < ActionController::API
  include ActionController::Cookies
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_not_valid
  before_action :authorize 

  private

  def authorize 
    @current_user = User.find_by(id: session[:user_id])

    render json: { errors: ["Not authorized"] }, status: :unauthorized unless @current_user
  end

  def record_not_valid( invalid )
    render json: { errors: invalid.record.errors.full_messages }, status: 422
  end 

  def record_not_found( invalid )
    render json: { error: "#{invalid.model} not found" }, status: :not_found
  end

end
