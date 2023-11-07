class DateInFutureValidator < ActiveModel::EachValidator
  
  # カスタムバリデータ作成
  # 必ずvalidate_eachメソッドでモデルインスタンス、検証する属性、検証する属性値を受け取る
  def validate_each(record, attribute, value)
    
    if value.present? && value < Date.current
      record.errors.add(attribute,":過去の日付は使用できません")
    end
    
  end
  
end
