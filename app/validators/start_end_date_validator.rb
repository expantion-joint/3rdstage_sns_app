class StartEndDateValidator < ActiveModel::EachValidator
  
  # カスタムバリデータ作成
  # 必ずvalidate_eachメソッドでモデルインスタンス、検証する属性、検証する属性値を受け取る
  def validate_each(record, attribute, value)
    
    event_date = record.send(options[:event_date_attribute])
    start_date = record.send(options[:start_date_attribute])
    end_date = value
    
    if start_date.present? && end_date.present? && event_date.present?
      
      if start_date > end_date
        record.errors.add(attribute,":終了日は開始日より後の日付にしてください")
      end
      
      if end_date > event_date
        record.errors.add(attribute,":終了日はイベント開催日より前の日付にしてください")
      end
      
    else
      
      record.errors.add("開催日、開始時間、終了時間を入力してください")
      
    end
  
  end
  
end
