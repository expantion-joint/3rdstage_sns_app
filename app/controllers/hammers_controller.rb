class HammersController < ApplicationController

  before_action :authenticate_user!

  skip_before_action :authenticate_user!, only: [:batch_create]
  skip_before_action :verify_authenticity_token, only: [:batch_create]
  before_action :authenticate_api_key, only: [:batch_create]  


  def index
    hammers_all = Hammer.all
    userid = current_user.id
    @bids = []
    @posts = []

    bid_ids = hammers_all.map do |hammer|
      hammer.bid_id
    end

    bid_ids.each do |bidid|
      bid = Bid.find(bidid)
      
      if bid.user_id == userid
        @bids << bid
        post = Post.find(bid.post_id)
        @posts << post
      end

    end

    render :index
  end


  def batch_create
    # 現在価格算出　→ 落札
    puts "================ batch create start #{Time.zone.now} ================"
    bids_all = Bid.all
    posts_all = Post.all
    hammers_all = Hammer.all
    bids_post_users_max = []
    sorted_bids_post_users_max = []

    post_ids = posts_all.map do |post|
      post.id
    end
    
    post_ids.each do |postid|

      bids_post_users_max.clear
      sorted_bids_post_users_max.clear

      post_postid = Post.find(postid)
      post_postid_count = post_postid.count

      if post_postid.end_time < Time.zone.now

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

        bid_ids = hammers_all.map do |hammer|
          hammer.bid_id
        end

        tmp_count = post_postid_count - 1
        (0..tmp_count).each do |index|
          tmp = 0
          if sorted_bids_post_users_max[index].nil?
          else
            bid_ids.each do |bidid|
              if sorted_bids_post_users_max[index].id == bidid
                puts "落札済:#{sorted_bids_post_users_max[index].id}"
                tmp = tmp + 1
              end
            end
            if tmp == 0
              @hammer = Hammer.new
              @hammer.bid_id = sorted_bids_post_users_max[index].id
              @bid = Bid.find(@hammer.bid_id)
              @user = User.find(@bid.user_id)
              @hammer.user_id = @user.id
              @hammer.post_id = postid
              @hammer.payment_history = "unpaid"  # unpaid:未払い processing：支払い中　succeeded:支払い済
              puts "新規落札:#{@hammer.bid_id}"
              if @hammer.save
                begin
                  HammerMailer.send_mail(@hammer).deliver_now
                  puts "メール送信完了:#{@hammer.bid_id}"
                rescue => e
                  puts '---メール送信エラー---'
                  puts @hammer.bid_id
                  puts "An error occurred: #{e.message}"
                  puts '----------------------'
                end
              else
                puts '---新規落札エラー---'
                puts @hammer.bid_id
                puts '--------------------'
              end 
            end
          end
        end
      end
    end
    puts "================ batch create end #{Time.zone.now} ================"
  end
  

  def show
    @users = []
    @bids = []

    @post = Post.find(params[:id])
    @hammers = Hammer.where(post_id: params[:id]) # 完全一致
    @hammers.each do |hammer|
      @bids << Bid.find(hammer.bid_id)
    end

    @Num_of_hammer = @hammers.size
    
    @hammers.each do |hammer|
      @users << User.find(hammer.user_id)
      # # 年齢計算
      # user = User.find(bid.user_id)
      # birth_date = user.birthday
      # today = Time.zone.today
      # this_years_birthday = Time.zone.local(today.year, birth_date.month, birth_date.day)
      # age = today.year - birth_date.year
      # if today < this_years_birthday
      #   age -= 1
      # end
      # @ages << age
    end

    render :show
  end


  private
  def authenticate_api_key

    require 'digest'
    plain_text = "bdj49e2fEEn4#{Time.zone.now}Lit3ssdHQw0jTc" # APIキー
    hashed_text = Digest::SHA256.hexdigest(plain_text)

    api_key = request.headers['Authorization']
    unless api_key && api_key == hashed_text # APIキー
      head :unauthorized
    end
  end
end
