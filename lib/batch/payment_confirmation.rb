class Batch::PaymentConfirmation
    def self.payment_confirmation
      
      puts 'payment_confirmation_batch'
      puts Time.current.strftime('%Y-%m-%d %H:%M')

      require 'digest'
      plain_text = "PaymentConfirmation#{Time.zone.now}Batch" # APIキー
      hashed_text = Digest::SHA256.hexdigest(plain_text)
  
      require 'net/http'
      uri = URI('http://rails:3000/')
      hostname = uri.hostname
      uri.path = '/purchasing_quantities/batch_payment_confirmation'  # 変更されたパス
      req = Net::HTTP::Post.new(uri)
      req.content_type = 'application/json'
      req['Authorization'] = hashed_text  # APIキーを追加 35文字程度のランダムな文字列
  
      begin
        res = Net::HTTP.start(hostname, uri.port) do |http|
          http.request(req)
        end
      rescue => e
        puts "An error occurred: #{e.message}"
      end
    end
  end