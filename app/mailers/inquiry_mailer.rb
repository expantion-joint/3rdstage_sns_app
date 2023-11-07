class InquiryMailer < ApplicationMailer

    def send_mail(inquiry)
      @inquiry = inquiry
      mail(
        to: @inquiry.email,
        from: 'Festival Auction',
        subject: 'お問い合わせ通知'
      )
    end

end
