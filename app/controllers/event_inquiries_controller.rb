class EventInquiriesController < ApplicationController
  
    before_action :authenticate_user!
  
    def new
      @event_inquiry = EventInquiry.new
      render :new
    end
    
    def create
      @event_inquiry = EventInquiry.new(event_inquiry_params)
      user = User.find(@event_inquiry.user_id)
      post = Post.find(@event_inquiry.post_id)
      contributor = User.find(post.user_id)
      @event_inquiry.contributor_email = contributor.email
      @event_inquiry.name = user.last_name + user.first_name
  
      if @event_inquiry.save
        begin
          InquiryMailer.send_mail(@event_inquiry).deliver_now
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
    def event_inquiry_params
      params.require(:event_inquiry).permit(:name, :subject, :email, :message).merge(user_id: current_user.id, post_id: params[:id])
    end
    
end
