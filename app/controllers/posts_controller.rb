class PostsController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]
  
  def top
    render :top
  end
  
  def new
    # sessionを破棄（保存されたデータを破棄）
    session.delete(:post)
    # Postオブジェクトを作成し初期化
    @post = Post.new
    # new.html.erbを呼び出す
    render :new # renders app/views/posts/new.html.erb
  end
  
  
  def index
    
    @festival_name = params[:festival_name]
    
    # 終了した祭りを除外してから表示しないと、将来現在価格の計算数どんどん増えてく
    # 検索された祭り名のイベントを表示
    if @festival_name.present?
      @posts = Post.where('festival_name LIKE ?', "%#{@festival_name}%")
    else
      @posts = Post.all
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
    render :index # renders app/views/posts/index.html.erb
  end


  def contributor_index
    userid = current_user.id
    
    # 検索されたuser_idのイベントを表示
    if userid.present?
      @posts = Post.where(user_id: userid) # 完全一致
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
    render :contributor_index
  end


  def create
    # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
    @post = Post.new(post_params)

    # imageが存在するか？
    if params[:post][:image]
      # @postオブジェクトにimageを添付
      @post.image.attach(params[:post][:image])
    end
    
     # データベースへの保存が成功すればtrue
    if @post.save
      redirect_to new_successful_bidder_limited_path(@post.id), notice: '投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  
  def complete
    @post = Post.find(params[:id]) # post.id
    @successful_bidder_limited = SuccessfulBidderLimited.find_by(post_id: params[:id]) #post.id
    render :complete
  end

  # -----以下、入力→確認→完了バージョン　画像が保存できないためコメントアウト-----
  # def confirm
  #   # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
  #   @post = Post.new(post_params)

  #   # imageが存在するか？
  #   if params[:post][:image]
  #     # @postオブジェクトにimageを添付
  #     @post.image.attach(params[:post][:image])
  #   end
    
  #   # session[キー] = "値" キーと値をペアでデータ保存
  #   # 入力(new) → 確認(confim) → 完了(complete) 入力値を完了まで保存
  #   session[:post] = @post
    
  #   # エラーが発生した場合true
  #   if @post.invalid?
  #     render :new
  #   else
  #     render :confirm
  #   end
    
  # end
  
  # def complete
  #   @post = Post.new(session[:post])
    
  #   # imageが存在するか？
  #   if params[:post][:image]
  #     # @postオブジェクトにimageを添付
  #     @post.image.attach(params[:post][:image])
  #   end
    
  #   # データベースへの保存が成功すればtrue
  #   if @post.save
  #     redirect_to new_successful_bidder_limited_path(@post.id), notice: '投稿しました'
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  #   # sessionを破棄
  #   session.delete(:post)
  # end

  # def back
  #   # session[:post]　記憶されたpostモデルを参照（保存されたデータを取り出す）
  #   @post = Post.new(session[:post])
  #   # sessionを破棄
  #   session.delete(:post)
  #   render :new
  # end
  # ----------------------------ここまで----------------------------
  

  def edit
    
    # URLから取得したidパラメータを使用し、データベースから対象の投稿を取得
    @post = Post.find(params[:id])
    render :edit
    
  end
  

  def update
    
    @post = Post.find(params[:id])
    @post_params = Post.new(post_params)
    
    # imageが存在するか？
    if params[:post][:image]
      # @postオブジェクトにimageを添付
      @post.image.attach(params[:post][:image])
    end

    @result = "success"
    
    if @post.start_time > Time.zone.now 
      if @post_params.start_time > Time.zone.now && @post_params.end_time > @post_params.start_time && @post_params.event_date > @post_params.end_time
        # post_paramsから送信されたデータを使って投稿を更新
        if @post.update(post_params)
          redirect_to contributor_index_post_path(current_user.id), notice: '更新しました'
        else
          render :edit, status: :unprocessable_entity
        end
      else
        @result = "error"
        @message1 = "オークション開始日時に過去の日付は使用できません"
        @message2 = "オークション終了日時は、開始日時より将来の日付にしてください"
        @message3 = "イベント開催日は、オークション終了日時より将来の日付にしてください"
        render :edit
      end
    else
      if @post.update(post_params)
        redirect_to contributor_index_post_path(current_user.id), notice: '更新しました'
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
  end
  
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to index_post_path, notice: '削除しました'
  end
  
  
  def show
    # findはモデルの検索機能を持つメソッド
    # モデルと紐づいているデータベースのテーブルから、レコードを1つ取り出す
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
    @bid = Bid.new

    # 現在価格算出
    bids_all = Bid.all
    bids_post_users_max = []
    sorted_bids_post_users_max = []

    bids_for_post = bids_all.select { |bid| bid.post_id == @post.id }
      
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
    
    post_postid_count = @post.count

    tmp_count = post_postid_count - 1
    @bid_price_now = sorted_bids_post_users_max[tmp_count]

    render :show
  end
  
  private
  
  def post_params
    params.require(:post).permit(:festival_name, :event_name, :category, :content, :event_date, :venue, :start_time, :end_time, :start_price, :count, :image).merge(user_id: current_user.id)
    # params.require(:モデル名).permit(:カラム名１,：カラム名２,・・・).merge(カラム名: 入力データ)
  end
  
end
