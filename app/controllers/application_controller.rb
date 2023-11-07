class ApplicationController < ActionController::Base
  
  # deviseのメソッド
  # before_action :authenticate_user!, except: [:show, :index]
  # 全てのアクションの前に、ユーザーがログインしているかどうか確認する！
  # ただし、showアクションと、indexアクションが呼び出された場合は、除くよ。という意味になります
  
  before_action :authenticate_user!
  
end