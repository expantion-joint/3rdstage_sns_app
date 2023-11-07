class TicketBuyersLimitedController < ApplicationController

  before_action :authenticate_user!

  def new
    # sessionを破棄（保存されたデータを破棄）
    session.delete(:ticket_buyer_limited)
    # Postオブジェクトを作成し初期化
    @ticket_buyer_limited = TicketBuyerLimited.new
    # new.html.erbを呼び出す
    render :new # renders app/views/posts/new.html.erb
  end
  
  def create
    # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
    @ticket_buyer_limited = TicketBuyerLimited.new(ticket_buyer_limited_params)
    # データベースへの保存が成功すればtrue
    if @ticket_buyer_limited.save
    redirect_to complete_post_ticket_path(params[:id]), notice: '投稿しました'  # post_ticket.id
    else
    render :new, status: :unprocessable_entity
    end
  end     

  def edit 
    # URLから取得したidパラメータを使用し、データベースから対象の投稿を取得
    @ticket_buyer_limited = TicketBuyerLimited.find_by(post_ticket_id: params[:id])
    if @ticket_buyer_limited.nil?
        redirect_to new_ticket_buyer_limited_path
    else
        render :edit
    end
  end
  
  def update
    @ticket_buyer_limited = TicketBuyerLimited.find_by(post_ticket_id: params[:id])
    # post_paramsから送信されたデータを使って投稿を更新
    if @ticket_buyer_limited.update(ticket_buyer_limited_params)
      redirect_to contributor_index_post_ticket_path, notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end
    
  def show
    @ticket_buyer_limited = TicketBuyerLimited.find_by(post_ticket_id: params[:id])
    render :show
  end

  private
  def ticket_buyer_limited_params
    params.require(:ticket_buyer_limited).permit(:set_time, :set_location, :suspension, :message, :contact_address).merge(post_ticket_id: params[:id])
    # params.require(:モデル名).permit(:カラム名１,：カラム名２,・・・).merge(カラム名: 入力データ)
  end

end
