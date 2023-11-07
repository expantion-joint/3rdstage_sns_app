class HammerMailer < ApplicationMailer

    def send_mail(hammer)
      @hammer = hammer
      @bid = Bid.find(@hammer.bid_id)
      @post = Post.find(@bid.post_id)
      @user = User.find(@bid.user_id)
      mail(
        to: @user.email,
        from: 'Festival Auction',
        subject: 'お問い合わせ通知'
      )
    end

end
