module MenuHelper

  def build_tree(id, depth)
    s = ''
    if id == 0
      s += '主選單<br>'
      @list << ['主選單', id]
    elsif id == -1
      s += '子選單<br>'
      @list << ['子選單', id]
    else
      item = @hash[id]
      @list << [item.title, id]
      s += '  ' * depth + [item.title, item.url, item.order].join(', ') + " <a href=/menu/edit_menu/#{id}>編輯</a> | "+link_to('刪除', {:action => 'del_menu', :id => id}, :method => :post, :confirm => '確定要刪除嗎？')+"</a><br>"
    end
    if @children[id]
      for child in @children[id]
        s += build_tree(child.id, depth+1)
      end
    end
    return s
  end

end
