class UsersController < ApplicationController
  before_action :authorize_request, except: %i[register login send_otp index]
  # GET /index
  def index
    @users = User.all
    render json: @users, status: :ok
  end
  # POST /register
  def register
    @user = User.create(user_params)
    if @user.save
     response = { message: 'User created successfully'}
     render json: response, status: :created
    else
     render json: @user.errors, status: :bad
    end
  end

  def login
    @identification = params[:identification]
    @otp = params[:otp]
    if email_valid?(@identification)
      @user = User.find_by_email(params[:identification])
      if @user.otp.to_s == @otp
        render json: {message: "Login successful"}, status: :created
      else
        render json: {message: "Enter valid OTP"}, status: :created
      end
    elsif contact_valid?(@identification)
      if @user.otp.to_s == @otp
        render json: {message: "Login successful"}, status: :created
      else
        render json: {message: "Enter valid OTP"}, status: :created
      end
    else
      render json: {message: "Wrong identification"}, status: :created
    end
  end

  def send_otp
    # byebug
    @identification = params[:identification]
    if num_valid?(@identification)
      if contact_valid?(@identification)
        if User.exists?(contact: @identification)
          handle_otp(contact: @identification)
        else
          render json: {message: "Contact doesn't exist"}, status: :created
        end
      else
        render json: {message: "Contact invalid"}, status: :created
      end
    else
      if email_valid?(@identification)
        if User.exists?(email: @identification)
          handle_otp(email: @identification)
        else
          ender json: {message: "Email doesn't exist"}, status: :created
        end
      else
        render json: {message: "Email invalid"}, status: :created
      end
    end
  end

  private

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
  VALID_CONTACT_REGEX = /^[6-9]\d{9}$/
  VALID_NUM_REGEX = /^[1-9]\d*$/

  def email_valid?(email)
    email =~ VALID_EMAIL_REGEX
  end

  def contact_valid?(contact)
    contact =~ VALID_CONTACT_REGEX
  end

  def num_valid?(num)
    num =~ VALID_NUM_REGEX
  end

  def handle_otp(options)
    @otp = rand.to_s[2..6]
    if num_valid?(@identification)
      # User.update(contact: options[:contact], otp: @otp)
      User.where(contact: options[:contact]).update(otp: @otp)
      render json: {message: "An OTP has been sent to your contact :  #{@otp}"}, status: :created
    else
      User.where(email: options[:email]).update(otp: @otp)
      render json: {message: "An OTP has been sent to your email:  #{@otp}"}, status: :created
    end
  end

  def user_params
    params.permit(
      :name,
      :email,
      :contact,
      :password
    )
  end
end
