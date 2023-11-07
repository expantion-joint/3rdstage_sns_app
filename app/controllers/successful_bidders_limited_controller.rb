class SuccessfulBiddersLimitedController < ApplicationController

    before_action :authenticate_user!

    def new
      # sessionを破棄（保存されたデータを破棄）
      session.delete(:successful_bidder_limited)
      # Postオブジェクトを作成し初期化
      @successful_bidder_limited = SuccessfulBidderLimited.new
      # new.html.erbを呼び出す
      render :new # renders app/views/posts/new.html.erb
    end


    def create
      # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
      @successful_bidder_limited = SuccessfulBidderLimited.new(successful_bidder_limited_params)
      # データベースへの保存が成功すればtrue
      if @successful_bidder_limited.save
        redirect_to complete_post_path(params[:id]), notice: '投稿しました'  # post.id
      else
        render :new, status: :unprocessable_entity
      end
    end     

    # -----以下、入力→確認→完了バージョン　必要ないためコメントアウト-----
    # def back
    #   # session[:post]　記憶されたpostモデルを参照（保存されたデータを取り出す）
    #   @successful_bidder_limited = SuccessfulBidderLimited.new(session[:successful_bidder_limited])
    #   # sessionを破棄
    #   session.delete(:successful_bidder_limited)
    #   render :new
    # end
      
      
    # def confirm
    #   # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
    #   @successful_bidder_limited = SuccessfulBidderLimited.new(successful_bidder_limited_params)
        
    #   # session[キー] = "値" キーと値をペアでデータ保存
    #   # 入力(new) → 確認(confim) → 完了(complete) 入力値を完了まで保存
    #   session[:successful_bidder_limited] = @successful_bidder_limited
        
    #   # エラーが発生した場合true
    #   if @successful_bidder_limited.invalid?
    #     render :new
    #   else
    #     render :confirm
    #   end 
    # end
      
      
    # def complete
    #   @successful_bidder_limited = SuccessfulBidderLimited.new(session[:successful_bidder_limited])
    #   # データベースへの保存が成功すればtrue
    #   if @successful_bidder_limited.save
    #     redirect_to index_post_path, notice: '投稿しました'
    #   else
    #     render :new, status: :unprocessable_entity
    #   end
    #   # sessionを破棄
    #   session.delete(:successful_bidder_limited)
    # end
    # -------------------------ここまで-------------------------
      
      
    def edit 
      # URLから取得したidパラメータを使用し、データベースから対象の投稿を取得
      @successful_bidder_limited = SuccessfulBidderLimited.find_by(post_id: params[:id])
      if @successful_bidder_limited.nil?
        redirect_to new_successful_bidder_limited_path
      else
        render :edit
      end
    end


    def update
      @successful_bidder_limited = SuccessfulBidderLimited.find_by(post_id: params[:id])
      # post_paramsから送信されたデータを使って投稿を更新
      if @successful_bidder_limited.update(successful_bidder_limited_params)
        redirect_to contributor_index_post_path, notice: '更新しました'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def show
      @successful_bidder_limited = SuccessfulBidderLimited.find_by(post_id: params[:id])
      render :show
    end

    private
    def successful_bidder_limited_params
      params.require(:successful_bidder_limited).permit(:set_time, :set_location, :suspension, :message, :contact_address).merge(post_id: params[:id])
      # params.require(:モデル名).permit(:カラム名１,：カラム名２,・・・).merge(カラム名: 入力データ)
    end

end
