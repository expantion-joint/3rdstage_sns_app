class TicketInquiriesController < ApplicationController

    before_action :authenticate_user!
  
    def new
      @ticket_inquiry = TicketInquiry.new
      render :new
    end
    
    def create
      @ticket_inquiry = TicketInquiry.new(ticket_inquiry_params)
      user = User.find(@ticket_inquiry.user_id)
      post_ticket = PostTicket.find(@ticket_inquiry.post_ticket_id)
      contributor = User.find(post_ticket.user_id)
      @ticket_inquiry.contributor_email = contributor.email
      @ticket_inquiry.name = user.last_name + user.first_name
  
      if @ticket_inquiry.save
        begin
          InquiryMailer.send_mail(@ticket_inquiry).deliver_now
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
    def ticket_inquiry_params
      params.require(:ticket_inquiry).permit(:name, :subject, :email, :message).merge(user_id: current_user.id, post_ticket_id: params[:id])
    end

end
