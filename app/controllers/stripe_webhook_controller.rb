class StripeWebhookController < ApplicationController
    
  # before_action :authenticate_user!

  # Set your secret key. Remember to switch to your live secret key in production.
  # See your keys here: https://dashboard.stripe.com/apikeys

  Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

  skip_before_action :verify_authenticity_token

  def create
    puts "------webhook------"
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :endpoint_secret)
    event = nil

    begin
      # event = Stripe::Event.construct_from(
      # JSON.parse(payload, symbolize_names: true)
      # )
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    # rescue JSON::ParserError => e
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      Rails.logger.debug e
      # Invalid payload
      status 400
      return
    end

    # Handle the event
    case event.type
    when 'checkout.session.completed'
      
      session = event.data.object # contains a Stripe::PaymentIntent
      @user = User.find_by(customer_id: session.customer)
      hammers_for_user = Hammer.where(user_id: @user.id) # 完全一致
      hammers_for_processing = hammers_for_user.select { |hammer| hammer.payment_history == "waiting_webhook" }
      hammer_ids = hammers_for_processing.map do |hammer|
        hammer.id
      end

      hammer_ids.each do |hammerid|
        hammer = Hammer.find(hammerid)
        bid = Bid.find(hammer.bid_id)
        if payment_intent.amount_total == bid.bid_price
          puts '------------------------------------'
          puts 'PaymentIntent was successful!'
          puts '------------------------------------'
          if hammer.update(payment_history: "succeeded" ) # unpaid:未払い processing：支払い中　succeeded:支払い済
          else
            puts '------------------------------------'
            puts 'SaveError:StripeWebhook'
            puts 'HammerId:' + hammer.id
            puts '------------------------------------'
          end
        end
      end
    else
      puts '------------------------------------'
      puts "Unhandled event type: #{event.type}"
      puts '------------------------------------'
    end

    status 200
  end

end
