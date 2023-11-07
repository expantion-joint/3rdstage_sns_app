class PostTicketsController < ApplicationController

  before_action :authenticate_user!

  def index
    @festival_name = params[:festival_name]

    if @festival_name.present?
      @post_tickets = PostTicket.where('festival_name LIKE ?', "%#{@festival_name}%")
    else
      @post_tickets = PostTicket.all
    end
    
    render :index
  end

  def new
    @post_ticket = PostTicket.new
    render :new
  end

  def create
    @post_ticket = PostTicket.new(post_ticket_params)

    if params[:post_ticket][:image]
        @post_ticket.image.attach(params[:post_ticket][:image])
    end

    if @post_ticket.save
      redirect_to new_ticket_buyer_limited_path(@post_ticket.id), notice: '投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    @post_ticket = PostTicket.find(params[:id])
    @user = User.find(@post_ticket.user_id)
    @purchasing_quantity = PurchasingQuantity.new

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

    render :show
  end

  def contributor_index
    @post_tickets = PostTicket.where(user_id: current_user.id) # 完全一致
    render :contributor_index
  end

  def edit
    @post_ticket = PostTicket.find(params[:id])
    render :edit
  end

  def update
    @post_ticket = PostTicket.find(params[:id])
    # imageが存在するか？
    if params[:post_ticket][:image]
      # @postオブジェクトにimageを添付
      @post_ticket.image.attach(params[:post_ticket][:image])
    end
    # post_paramsから送信されたデータを使って投稿を更新
    if @post_ticket.update(post_ticket_params)
      redirect_to contributor_index_post_ticket_path(current_user.id), notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end    
  end

  def destroy
    @post_ticket = PostTicket.find(params[:id])
    @post_ticket.destroy
    redirect_to index_post_ticket_path, notice: '削除しました'
  end

  def complete
    @post_ticket = PostTicket.find(params[:id]) #post_ticket.id
    @ticket_buyer_limited = TicketBuyerLimited.find_by(post_ticket_id: params[:id]) #post_ticket.id
    render :complete
  end


  private
  
  def post_ticket_params
    params.require(:post_ticket).permit(:festival_name, :event_name, :category, :content, :event_date, :venue, :price, :count, :unit, :total_purchases, :image).merge(user_id: current_user.id)
  end

end
