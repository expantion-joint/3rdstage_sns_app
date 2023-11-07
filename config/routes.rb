Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
  
  # --------メモ---------
  # post:作成 get:表示
  # posts/newにアクセスするとpostsのcreateアクションにアクセスする
  # create_post_passを指定するとpostsのcreateアクションにアクセスする
  # post 'posts/new', to: 'posts#create', as: 'create_post'
  # ---------------------

  # post
  get '/', to: 'posts#top', as: 'top_post'
  get 'posts/index', to: 'posts#index', as: 'index_post'
  get 'posts/contributor_index/:id', to: 'posts#contributor_index', as: 'contributor_index_post' # user.id
  get 'posts/new', to: 'posts#new', as: 'new_post'
  post 'posts/new', to: 'posts#create', as: 'create_post'
  get 'posts/complete/:id', to: 'posts#complete', as: 'complete_post' # post.id
  get 'posts/edit/:id', to: 'posts#edit', as: 'edit_post' # post.id
  post 'posts/edit/:id', to: 'posts#update', as: 'update_post' # post.id
  delete 'posts/destroy/:id', to: 'posts#destroy', as: 'destroy_post' # post.id
  get 'posts/show/:id', to: 'posts#show', as: 'show_post' # post.id
  
  # post 'posts/confirm', to: 'posts#confirm', as: 'confirm_post'
  # post 'posts/back', to: 'posts#back', as: 'back_post'
  # post 'posts/complete', to: 'posts#complete', as: 'complete_post'
  
  # user（投稿者）
  get 'users/contributors/edit/:id', to: 'users/contributors#edit', as: 'edit_user_contributor' # post.id
  post 'users/contributors/edit/:id', to: 'users/contributors#update', as: 'update_user_contributor' # post.id
  get 'users/contributors/show/:id', to: 'users/contributors#show', as: 'show_user_contributor' # post.id

  # user（非投稿者）
  get 'users/contributors/mypage_index', to: 'users/contributors#mypage_index', as: 'mypage_index_user_contributor'
  get 'users/contributors/mypage_edit/:id', to: 'users/contributors#mypage_edit', as: 'mypage_edit_user_contributor' # user.id
  post 'users/contributors/mypage_edit/:id', to: 'users/contributors#mypage_update', as: 'mypage_update_user_contributor' # user.id
  
  # bid
  get 'bids/index/:id', to: 'bids#index', as: 'index_bid' # user.id
  post 'bids/new/:id', to: 'bids#create', as: 'create_bid' # post.id
  
  # 本サイトに関する問い合わせ
  get 'inquiries/new/:id', to: 'inquiries#new', as: 'new_inquiry' # user.id
  post 'inquiries/new/:id', to: 'inquiries#create', as: 'create_inquiry' # user.id
  
  # イベント（オークション）に関する問い合わせ
  get 'event_inquiries/new/:id', to: 'event_inquiries#new', as: 'new_event_inquiry' # post.id
  post 'event_inquiries/new/:id', to: 'event_inquiries#create', as: 'create_event_inquiry' # post.id

  # イベント（チケット）に関する問い合わせ
  get 'ticket_inquiries/new/:id', to: 'ticket_inquiries#new', as: 'new_ticket_inquiry' # post_ticket.id
  post 'ticket_inquiries/new/:id', to: 'ticket_inquiries#create', as: 'create_ticket_inquiry' # post_ticket.id

  # hummer
  get 'hammers/index', to: 'hammers#index', as: 'index_hammer'
  post 'hammers/batch_create', to: 'hammers#batch_create', as: 'batch_create_hammer'
  get 'hammers/show/:id', to: 'hammers#show', as: 'show_hammer' # post.id

  # successful_bidder_limited
  get 'successful_bidders_limited/new/:id', to: 'successful_bidders_limited#new', as: 'new_successful_bidder_limited' # post.id
  post 'successful_bidders_limited/new/:id', to: 'successful_bidders_limited#create', as: 'create_successful_bidder_limited' # post.id
  get 'successful_bidders_limited/edit/:id', to: 'successful_bidders_limited#edit', as: 'edit_successful_bidder_limited' # post.id
  post 'successful_bidders_limited/edit/:id', to: 'successful_bidders_limited#update', as: 'update_successful_bidder_limited' # post.id
  get 'successful_bidders_limited/show/:id', to: 'successful_bidders_limited#show', as: 'show_successful_bidder_limited' # post.id

  # post 'successful_bidders_limited/confirm/:id', to: 'successful_bidders_limited#confirm', as: 'confirm_successful_bidder_limited'
  # post 'successful_bidders_limited/back/:id', to: 'successful_bidders_limited#back', as: 'back_successful_bidder_limited'
  # post 'successful_bidders_limited/complete/:id', to: 'successful_bidders_limited#complete', as: 'complete_successful_bidder_limited'

  # payment
  get 'payments/new/:id', to: 'payments#new', as: 'new_payment' # post.id
  get 'payments/after_payment_register', to: 'payments#after_payment_register', as: 'after_payment_register_payment'
  get 'payments/payment_cancel', to: 'payments#payment_cancel', as: 'payment_cancel_payment'
  get 'payments/ticket_new/:id', to: 'payments#ticket_new', as: 'ticket_new_payment' # post_ticket.id
  get 'payments/after_ticket_payment_register', to: 'payments#after_ticket_payment_register', as: 'after_ticket_payment_register_payment'
  get 'payments/ticket_payment_cancel', to: 'payments#ticket_payment_cancel', as: 'ticket_payment_cancel_payment'

  # stripe
  post 'stripe_webhook', to: 'stripe_webhook#create', as: 'create_stripe_webhook'

  # post_ticket
  get 'post_tickets/new', to: 'post_tickets#new', as: 'new_post_ticket'
  post 'post_tickets/new', to: 'post_tickets#create', as: 'create_post_ticket'
  get 'post_tickets/index', to: 'post_tickets#index', as: 'index_post_ticket'
  get 'post_tickets/edit/:id', to: 'post_tickets#edit', as: 'edit_post_ticket' # post_tickets.id
  post 'post_tickets/edit/:id', to: 'post_tickets#update', as: 'update_post_ticket' # post_tickets.id
  get 'post_tickets/show/:id', to: 'post_tickets#show', as: 'show_post_ticket' # post_tickets.id
  get 'post_tickets/contributor_index/:id', to: 'post_tickets#contributor_index', as: 'contributor_index_post_ticket' # user.id
  delete 'post_tickets/destroy/:id', to: 'post_tickets#destroy', as: 'destroy_post_ticket' # post_tickets.id
  get 'post_tickets/complete/:id', to: 'post_tickets#complete', as: 'complete_post_ticket' # post_tickets.id

  # purchasing_quantity
  post 'purchasing_quantities/new/:id', to: 'purchasing_quantities#create', as: 'create_purchasing_quantity' # post_tickets.id
  post 'purchasing_quantities/batch_payment_confirmation', to: 'purchasing_quantities#batch_payment_confirmation', as: 'batch_payment_confirmation'
  get 'purchasing_quantities/index', to: 'purchasing_quantities#index', as: 'index_purchasing_quantity'

  # ticket_buyers_limited
  get 'ticket_buyers_limited/new/:id', to: 'ticket_buyers_limited#new', as: 'new_ticket_buyer_limited' # post_tickets.id
  post 'ticket_buyers_limited/new/:id', to: 'ticket_buyers_limited#create', as: 'create_ticket_buyer_limited' # post_tickets.id
  get 'ticket_buyers_limited/edit/:id', to: 'ticket_buyers_limited#edit', as: 'edit_ticket_buyer_limited' # post_tickets.id
  post 'ticket_buyers_limited/edit/:id', to: 'ticket_buyers_limited#update', as: 'update_ticket_buyer_limited' # post_tickets.id
  get 'ticket_buyers_limited/show/:id', to: 'ticket_buyers_limited#show', as: 'show_ticket_buyer_limited' # post_tickets.id

end
