class PurchasingQuantitiesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:batch_payment_confirmation]
  skip_before_action :verify_authenticity_token, only: [:batch_payment_confirmation]
  before_action :authenticate_api_key, only: [:batch_payment_confirmation]  

  def index
    purchasing_quantities_all = PurchasingQuantity.all
    userid = current_user.id
    @post_tickets = []
  
    purchasing_quantities_all.each do |purchasing_quantity|
      if purchasing_quantity.user_id == userid
        if purchasing_quantity.payment_history == "waiting_webhook"
          @post_tickets << PostTicket.find(purchasing_quantity.post_ticket_id)
        end
      end
    end
    
    render :index
  end

  def show
  
  end


  def create
    session.delete(:purchasing_quantity)
    @purchasing_quantity = PurchasingQuantity.new(purchasing_quantity_params)
    @post_ticket = PostTicket.find(@purchasing_quantity.post_ticket_id)
    @purchasing_quantity.payment_history = "processing"

    # 在庫の計算 
    # ---- ここから ----
    purchasing_quantities_for_post_ticket = PurchasingQuantity.where(post_ticket_id: @post_ticket.id) # 完全一致
    if purchasing_quantities_for_post_ticket.nil?
      @remain = @post_ticket.count
    else
      purchasing_quantities_for_post_ticket_for_unpaid = purchasing_quantities_for_post_ticket.where(payment_history: "unpaid") # 完全一致
      count_array = purchasing_quantities_for_post_ticket.map do |purchasing_quantity|
        purchasing_quantity.count
      end
      if purchasing_quantities_for_post_ticket_for_unpaid.nil?
        @remain = count_array.sum
      else
        count_array_for_unpaid = purchasing_quantities_for_post_ticket_for_unpaid.map do |purchasing_quantity|
          purchasing_quantity.count
        end
        purchased_quantities = count_array.sum - count_array_for_unpaid.sum
        @remain = @post_ticket.count - purchased_quantities
      end
    end
    # ---- ここまで ----

    session[:purchasing_quantity] = @purchasing_quantity

    if @remain != 0
      after_purchase = @remain - @purchasing_quantity.count
      if after_purchase < 0
        session.delete(:purchasing_quantity)
        @user = User.find(@post_ticket.user_id)
        redirect_to index_post_ticket_path, notice: "購入希望数が在庫を超えています"
      else
        if @purchasing_quantity.save
          redirect_to ticket_new_payment_path(@post_ticket.id), notice: "購入しました"
        else
          session.delete(:purchasing_quantity)
          @user = User.find(@post_ticket.user_id)
          render :'post_tickets/show', status: :unprocessable_entity
        end
      end
    else
      session.delete(:purchasing_quantity)
      @user = User.find(@post_ticket.user_id)
      redirect_to index_post_ticket_path, notice: "販売を終了しました"
    end
  end

  def batch_payment_confirmation
    puts "========= batch payment confirmation start #{Time.zone.now} ========="
    purchasing_quantities_all = PurchasingQuantity.all
    processing_array = purchasing_quantities_all.where(payment_history: "processing") # 完全一致

    time_threshold = 30.minutes.ago # time_thresholdは現在時刻より30分前の時刻を示す

    unpaid_array = processing_array.where("created_at <= ?", time_threshold)
    unpaid_array.each do |record|
      puts "---- processing → unpaid ----"
      puts record.id
      puts "-----------------------------"
      record.update(payment_history: 'unpaid')
    end
    puts "========== batch payment confirmation end #{Time.zone.now} =========="
  end
  
  private
  def purchasing_quantity_params
    params.require(:purchasing_quantity).permit(:count, :payment_history).merge(post_ticket_id: params[:id], user_id: current_user.id)
    # params.require(:モデル名).permit(:カラム名１,：カラム名２,・・・).merge(カラム名: 入力データ)
  end

  def authenticate_api_key

    require 'digest'
    plain_text = "PaymentConfirmation#{Time.zone.now}Batch" # APIキー
    hashed_text = Digest::SHA256.hexdigest(plain_text)

    api_key = request.headers['Authorization']
    unless api_key && api_key == hashed_text # APIキー
      head :unauthorized
    end
  end

end
