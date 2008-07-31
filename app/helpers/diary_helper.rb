module DiaryHelper

  def get_diary_parent(parent)
    if parent == '0'
      return '消息公告'
    elsif parent == '-1'
      return '更新日誌'
    else
      return "#{parent} 未定義"
    end
  end

end
