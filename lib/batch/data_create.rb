class Batch::DataCreate
    def self.data_create
      
      puts 'data_create_batch'
      puts Time.current.strftime('%Y-%m-%d %H:%M')

      require 'digest'
      plain_text = "bdj49e2fEEn4#{Time.zone.now}Lit3ssdHQw0jTc" # APIキー
      hashed_text = Digest::SHA256.hexdigest(plain_text)
  
      require 'net/http'
      uri = URI('http://rails:3000/')
      hostname = uri.hostname
      uri.path = '/hammers/batch_create'  # 変更されたパス
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