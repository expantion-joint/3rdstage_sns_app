class BidsController < ApplicationController
  
  before_action :authenticate_user!

  def index
    # 入札価格算出
    userid = current_user.id

    @my_bids = []
    @posts = []
      
    bids_for_user = Bid.where(user_id: userid).each do |bid|
    end

    bids_user_post_ids = bids_for_user.map do |bid|
      bid.post_id
    end
        
    uniq_bids_user_post_ids = bids_user_post_ids.uniq

    uniq_bids_user_post_ids.each do |post|
      bids_for_post = bids_for_user.select { |bid| bid.post_id == post }
      max_bid_price = bids_for_post.maximum(:bid_price)
      max_my_bid = bids_for_post.find { |bid| bid.bid_price == max_bid_price }
      max_my_bid_post = Post.find(max_my_bid.post_id)
      if max_my_bid_post.end_time > Time.zone.now
        @my_bids << max_my_bid
        @posts << max_my_bid_post
      end
    end

    # 現在価格算出
    @bid = Bid.new
    @bids = []
    bids_all = Bid.all
    bids_post_users_max = []
    sorted_bids_post_users_max = []

    post_ids = @posts.map do |post|
      post.id
    end
    
    post_ids.each do |postid|

      bids_post_users_max.clear
      sorted_bids_post_users_max.clear

      bids_for_post = bids_all.select { |bid| bid.post_id == postid }
      
      bid_user_ids = bids_for_post.map do |bid|
        bid.user_id
      end

      uniq_bid_user_ids = bid_user_ids.uniq

      uniq_bid_user_ids.each do |bid_user_id|
        bids_post_user = bids_for_post.select { |bid| bid.user_id == bid_user_id }
        bid_post_user_max_price = bids_post_user.maximum(:bid_price)
        bids_post_users_max << bids_post_user.find { |bid| bid.bid_price == bid_post_user_max_price }
      end

      sorted_bids_post_users_max = bids_post_users_max.sort_by { |bid| -bid[:bid_price] } # 同じ値は元々の順番が適用される → 入札が早い順
      
      post_postid = Post.find(postid)
      post_postid_count = post_postid.count

      tmp_count = post_postid_count - 1
      (0..tmp_count).each do |index|
        @bids << sorted_bids_post_users_max[index]
      end
    
    end

    # index.html.erbを呼び出す
    render :index
  end
  
  def create
    # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
    @bid = Bid.new(bid_params)
    @bid.post_id = params[:id]
    @post = Post.find(@bid.post_id)

    if @post.end_time > Time.zone.now
      if @bid.save
        redirect_to index_bid_path(@bid.user_id), notice: "入札しました"
      else
        @user = User.find(@post.user_id)
        render :'posts/show', status: :unprocessable_entity
      end
    else
      @user = User.find(@post.user_id)
      redirect_to index_post_path, notice: "オークションは終了しました"
    end
  end


  private
  def bid_params
    params.require(:bid).permit(:bid_price).merge(post_id: params[:post_id], user_id: current_user.id)
    # params.require(:モデル名).permit(:カラム名１,：カラム名２,・・・).merge(カラム名: 入力データ)
  end

end
