# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def getauthorlist(hash, author)
    author.split(', ').map{|author|
      if user=User.find_by_id(author)
        user.username
      end
    }.join('、')
  end

  def get_error_message(target)
    return error_messages_for target
  end

  def get_std_time(time=nil)
    if time
      time.to_s(:db)
    else
      ''
    end
  end

  def format_content(content)
    content = content.gsub(/<nohtml>(.*?)<\/nohtml>/m) {|s|
      h($1)
    }.gsub(/  +/){|s|
      s.gsub(' ', "&nbsp;")
    }
    return content
  end

  def get_username(id)
    if user=User.find_by_id(id)
      return user.username
    else
      return '無此人或已被刪除！'
    end
  end
	
	def get_cattype_name(id)
		if id == -1
			return '題庫'
		elsif id == -2
			return '題型'
		else
			return "Category ##{id}"
		end
	end
	
	def get_cat_hash
		@cat_hash = {}
		Category.find(:all).each{|item|
			@cat_hash[item.id] = item
		}
	end
	
	def get_cat_tree
		@cat_child = {}
		Category.find(:all, :order => '`parent`, `order`').each{|item|
			unless @cat_child[item.parent.to_i]
				@cat_child[item.parent.to_i] = []
			end
			@cat_child[item.parent.to_i] << item
		}
	end
	
	def get_cat_type(id)
		unless parent=Category.find_by_id(id)
			return id
		end
		return get_cat_type(parent.parent.to_i)
	end

  def getclass(item)
    unless @cat_hash
			get_cat_hash
		end
		item ||= ''
		list = []
		item.split(', ').each{|item|
			if @cat_hash[item.to_i] and get_cat_type(item.to_i) == -2
				list << @cat_hash[item.to_i].title
			end
		}
		return list.join('、 ')
  end
	
	def get_cat_path(cat)
		unless parent=Category.find_by_id(cat.parent)
			return get_cattype_name(cat.parent.to_i) + ' => ' + cat.title
		end
		return get_cat_path(parent) + ' => ' + cat.title
	end

  def get_category(cat)
    cat ||= ''
    cat_list = []
    cat.split(', ').each{|item|
      temp = Category.find_by_id(item)
      if temp
        cat_list << get_cat_path(temp)
      end
    }
    return cat_list.join('<br>')
  end
	
	def put_cat_button
		return '<div id=cat_hidden_link><a href="javascript: hideCat()">隱藏</a></div>' + 
					 '<div id=cat_show_link><a href="javascript: showCat()">顯示</a></div>'
	end
	
	def get_about_link(s)
		str = ''
		s.split(', ').each{|item|
			temp = item.split('::')
			link = temp[0]
			showname = temp[1]
			if temp[0].blank?
				link = '#'
			end
			if temp[1].blank?
				showname = link
			end
			str += "<a href=\"#{link}\">#{showname}</a><br>"
		}
		return str
	end
	
	def get_permission_name(id)
		if cat=Permission.find_by_id(id)
			cat.title
		else
			'平民百姓'
		end
	end
	
	def get_permission_list
		@permission_list = Permission.find(:all)
	end

end
