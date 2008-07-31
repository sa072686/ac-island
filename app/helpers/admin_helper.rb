module AdminHelper

  def get_list(list)
    list ||= []
    list.map{|item|
      link_to item[0], item[1]
    }.join('<br>')
  end

end
