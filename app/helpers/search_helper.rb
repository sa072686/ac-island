module SearchHelper

  def get_search_typelist
    list = [['problem', '題目列表']]
    str = '<select name=type>'
    for item in list
      str += "<option value=#{item[0]}>#{item[1]}</option>"
    end
    str += '</select>'
    return str
  end

  def get_search_targetlist
    list = [['title', '標題'], ['content', '內文'], ['author', '作者']]
    str = '<select name=target>'
    for item in list
      str += "<option value=#{item[0]}>#{item[1]}</option>"
    end
    str += '</select>'
    return str
  end

end
