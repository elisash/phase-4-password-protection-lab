class UsersController < ApplicationController
  before_action :authorize # only: [:show]
  skip_before_action :authorize, only: [:create]

  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: {
               errors: user.errors.full_messages,
             },
             status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: session[:user_id])
    if user.valid?
      render json: user
    else
      render json: { error: "unauthorized" }, status: 401
    end
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def authorize
    unless session.include? :user_id
      return render json: { error: "Not Authorized" }, status: :unauthorized
    end
  end
end
