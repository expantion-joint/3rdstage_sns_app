class InquiriesController < ApplicationController
  
  before_action :authenticate_user!
  
  def new
    @inquiry = Inquiry.new
    render :new
  end
  
  def create
    @inquiry = Inquiry.new(inquiry_params)
    @user = User.find(@inquiry.user_id)
    @inquiry.name = @user.last_name + @user.first_name

    if @inquiry.save
      begin
        InquiryMailer.send_mail(@inquiry).deliver_now
        render :new, notice: 'メールが送信されました'
      # TODO:エラー処理はこれで良いか？  
      rescue => e
        puts "An error occurred: #{e.message}"
        render :new, notice: 'メールの送信中にエラーが発生しました。もう一度お試しください。'
      end
    else
      render :new, status: :unprocessable_entity
    end 
  end

  private
  def inquiry_params
    params.require(:inquiry).permit(:name, :subject, :email, :message).merge(user_id: params[:id])
  end
  
end
