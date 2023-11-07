class Users::ContributorsController < ApplicationController
  
  before_action :authenticate_user!

  # ----- 投稿者登録用 -----
  def index
    render :index
  end
    
  def update
    # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
    @user_params = User.new(user_params)
    @user = User.find(params[:id])
        
    # imageが存在するか？
    if params[:user][:image]
      # @userオブジェクトにimageを添付
      @user.image.attach(params[:user][:image])
    end

    @result = "success" 
    @message = "入力誤り："
    
    # 口座関係で未入力があった場合、登録画面に戻る
    if !@user_params.financial_institution.match?(/\A\d{4}\z/)
      @result = "error" 
      @message = @message + "金融機関コード・"
    end

    if !@user_params.branch_name.match?(/\A\d{3}\z/)
      @result = "error" 
      @message = @message + "支店コード・"
    end

    if @user_params.deposit_type == "当座" || @user_params.deposit_type == "普通" || @user_params.deposit_type == "貯蓄"
    else
      @result = "error" 
      @message = @message + "口座種目・"
    end
      
    if !@user_params.account_number.match?(/\A\d{7,8}\z/)
      @result = "error" 
      @message = @message + "口座番号・"
    end
      
    if @user_params.account_name.nil? || @user_params.account_name.match?(/[\u4e00-\u9fa5ぁ-ん]/) || @user_params.account_name.blank?
      @result = "error" 
      @message = @message + "口座名義・"
    end

    if @result == "error" 
      @message = @message.chop
      @user = User.new(user_params)
      render :edit
    else
      # contributor_code=2の場合、マイページに戻る
      if @user.contributor_code == 2
        if @user.update(user_params)
          redirect_to mypage_index_user_contributor_path, notice: '更新しました'
        else
          render :edit, status: :unprocessable_entity
        end
      else
        # 非投稿者:1, 投稿者:2
        @user.contributor_code = 2
        if @user.update(user_params)
          redirect_to index_post_path, notice: '登録しました'
        else
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def edit
    # URLから取得したidパラメータを使用し、データベースから対象の投稿を取得
    @user = User.find(params[:id])
    render :edit
  end

  # ----- マイページ用 -----
  def mypage_index
    render :mypage_index
  end

  def mypage_update
    # post_paramsメソッドを通じて受け取ったパラメータを使って初期化
    @user = User.find(params[:id])
        
    # imageが存在するか？
    if params[:user][:image]
      # @userオブジェクトにimageを添付
      @user.image.attach(params[:user][:image])
    end

    if @user.update(user_params)
      redirect_to mypage_index_user_contributor_path, notice: '更新しました'
    else
      render :mypage_edit, status: :unprocessable_entity
    end
  end

  def mypage_edit
    # URLから取得したidパラメータを使用し、データベースから対象の投稿を取得
    @user = User.find(params[:id])
    render :mypage_edit
  end

  def show
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
    render :show
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :display_name, :postcode, :prefecture_code, :address_city, :address_street, :address_building, :birthday, :contributor_code, :contributor_name, :contributor_festival, :contributor_introduction, :financial_institution, :branch_name, :deposit_type, :account_number, :account_name, :image)
    # params.require(:モデル名).permit(:カラム名１,：カラム名２,・・・).merge(カラム名: 入力データ)
  end

end
