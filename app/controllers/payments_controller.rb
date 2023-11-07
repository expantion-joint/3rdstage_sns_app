class PaymentsController < ApplicationController

  require 'stripe'
  
  def new

    # 落札価格算出
    @user = User.find(current_user.id)
    @post = Post.find(params[:id])
    max_price = 0
    
    bids_for_post = Bid.where(post_id: @post.id) # 完全一致
    bids_post_user = bids_for_post.select { |bid| bid.user_id == @user.id }
    bid_ids = bids_post_user.map do |bid|
      bid.id
    end
    
    bid_ids.each do |bidid|
      bid = Bid.find(bidid)
      if max_price < bid.bid_price
        max_price = bid.bid_price
        @bid = bid
      end
    end
    
    puts "------------------------"
    puts @user.id
    puts @post.id
    puts @bid.id
    puts "------------------------"

    session[:bid] = @bid

    # API
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    gon.stripe_public_key = Rails.application.credentials.dig(:stripe, :publishable_key)

    # Stripe Customer
    if @user.customer_id.nil?
      sender = Stripe::Customer.create({
        name: @user.last_name + @user.first_name,
        email: @user.email,
      })

      if @user.update(customer_id: sender.id)
      else
        redirect_to index_hammer_path, status: :unprocessable_entity
        return
      end
    end

    # Stripe Checkout
    @session = Stripe::Checkout::Session.create({
      customer: @user.customer_id,              # カスタマーID
      mode: 'payment',                          # 支払い方法（1回、サブスクなど）
      line_items: [{
        quantity: 1,                            # 商品数
        price_data: {
          currency: 'jpy',                      # 通貨
          unit_amount: @bid.bid_price,          # 価格
          product_data: {
            name: @post.event_name,             # 商品名
          }
        }
      }],
      payment_method_types: ['card'],           # 支払い方法（クレカなど）
      success_url: request.base_url + '/payments/after_payment_register?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: request.base_url + '/payments/payment_cancel',
    })
  end
  
  # 決済前のキャンセルのアクション
  def payment_cancel
    session.delete(:bid)
    redirect_to index_hammer_path
  end

  # 決済後のアクション
  def after_payment_register
    # stripe_user_data = Stripe::Checkout::Session.retrieve(params[:session_id])
    @bid = Bid.new(session[:bid])
    @hammer = Hammer.find_by(bid_id: @bid)
    if @hammer.update(payment_history: "waiting_webhook" ) # unpaid:未払い processing：支払い中 waiting_webhook:webhook待機中 succeeded:支払い済
      session.delete(:bid)
      redirect_to index_hammer_path
    else
      session.delete(:bid)
      puts '------------------------------------'
      puts 'SaveError:AfterPaymentRegidter'
      puts 'HammerId:' + @hammer.id
      puts '------------------------------------'
      redirect_to index_hammer_path
    end
  end

  # ----------- 以下、ticket -----------

  def ticket_new

    @user = User.find(current_user.id)
    @post_ticket = PostTicket.find(params[:id])

    # API
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    gon.stripe_public_key = Rails.application.credentials.dig(:stripe, :publishable_key)

    # Stripe Customer
    if @user.customer_id.nil?
      sender = Stripe::Customer.create({
        name: @user.last_name + @user.first_name,
        email: @user.email,
      })

      if @user.update(customer_id: sender.id)
      else
        redirect_to index_post_ticket_path, status: :unprocessable_entity
        return
      end
    end

    # Stripe Checkout
    @session = Stripe::Checkout::Session.create({
      customer: @user.customer_id,              # カスタマーID
      expires_at: Time.now.to_i + (1800),       # 30分後（1800秒後）にURLが執行するように設定
      mode: 'payment',                          # 支払い方法（1回、サブスクなど）
      line_items: [{
        quantity: 1,                            # 商品数
        price_data: {
          currency: 'jpy',                      # 通貨
          unit_amount: @post_ticket.price,      # 価格
          product_data: {
            name: @post_ticket.event_name,      # 商品名
          }
        }
      }],
      payment_method_types: ['card'],           # 支払い方法（クレカなど）
      success_url: request.base_url + '/payments/after_ticket_payment_register?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: request.base_url + '/payments/ticket_payment_cancel',
    })
    
  end

  # 決済前のキャンセルのアクション
  def ticket_payment_cancel
    session.delete(:purchasing_quantity)
    redirect_to index_post_ticket_path
  end

  # 決済後のアクション
  def after_ticket_payment_register
    # stripe_user_data = Stripe::Checkout::Session.retrieve(params[:session_id])
    session_purchasing_quantity = PurchasingQuantity.new(session[:purchasing_quantity])
    @purchasing_quantity = PurchasingQuantity.find(session_purchasing_quantity.id)

    if @purchasing_quantity.update(payment_history: "waiting_webhook" ) # unpaid:未払い processing：支払い中 waiting_webhook:webhook待機中 succeeded:支払い済
      session.delete(:purchasing_quantity)
      redirect_to index_post_ticket_path
    else
      session.delete(:purchasing_quantity)
      puts '------------------------------------'
      puts 'SaveError:AfterTicketPaymentRegidter'
      puts 'PurchasingQuantityId:' + @purchasing_quantity.id
      puts '------------------------------------'
      redirect_to index_post_ticket_path
    end
  end

end
