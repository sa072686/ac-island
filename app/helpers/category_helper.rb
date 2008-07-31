module CategoryHelper

  def get_tree(cat, depth)
    @list << cat
    str = "#{'&nbsp;'*(depth*2)}#{cat.title}, parent: #{cat.parent}, order: #{cat.order} "
    str += link_to('編輯', {:action => 'edit_category', :id => cat.id})
    str += ' | '
    str += link_to('刪除', {:action => 'del_category', :id => cat.id}, :method => :post, :confirm => '確定要刪除嗎？')
    str += '<br>'
    if @child[cat.id]
      for child in @child[cat.id]
        str += get_tree(child, depth+1)
      end
    end
    return str
  end

end
