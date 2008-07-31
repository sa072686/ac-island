module ProblemHelper

  def getlink(probid)
    list = probid.split(' ')
    oj = list[0]
    id = list[1].to_i
    link_name = '＋'
    if oj == 'ACM'
      str = sprintf('<a href="http://icpcres.ecs.baylor.edu/onlinejudge/external/%d/%d.html" target="_blank">%s</a>', id/100, id, link_name)
    elsif oj == 'TIOJ'
      str = sprintf('<a href="http://tmtacm.no-ip.org/JudgeOnline/showproblem?problem_id=%d" target="_blank">%s</a>', id, link_name)
    elsif oj == 'Ural'
      str = sprintf('<a href="http://acm.timus.ru/problem.aspx?space=1&num=%d" target="_blank">%s</a>', id, link_name)
    elsif oj == 'USACO'
      str = link_name
    else
      str = '無法辨識的題庫'
    end
  end

  def getprobname(problem)
    return problem.probid + ' - ' + problem.title
  end

  def getinnerlink(problem)
    return '<a href="/problem/viewproblem/'+problem.id.to_s+'">'+getprobname(problem)+'</a>'
  end

  def getdifficulty(diff)
    if diff and diff > 0
      return "★" * (diff/2) + "☆" * (diff%2)
    else
      return "未確定"
    end
  end

  def getcompleteness(com)
    if com and com.length > 0
      return com.split(', ').join('%/ ') + '%'
    else
      return ['0', '0', '0', '0'].join('%/ ') + '%'
    end
  end

  def get_tabs_link(text, own_id, divname, own_class)
    "<a href=\"javascript: clickTab('#{own_id}','#{divname}');\" id=#{own_id} class=\"#{own_class}\"> #{text} </a>"
  end

  def get_tabs(content, type)
    @tabs_id = -1
    contentlist = content.split(/\{tabs::.*?\}/)
    tablist = ['防雷頁']+content.scan(/\{tabs::(.*?)\}/).map{|item|
      item = item[0]
    }
    str = tablist.map{|item|
      @tabs_id += 1
      get_tabs_link(item, "#{type}_tab_id_#{@tabs_id}", "#{type}_id_#{@tabs_id}", "#{type}_tab")
    }.join(' ')
    if contentlist[0].blank?
      contentlist[0] = '為避免破壞思考樂趣，特留此貼心之防雷頁。'
    end
    id = 0
    display = ''
    for content in contentlist
      content = content.gsub(/^[\n\r]*/, '').gsub(/[\n\r]*$/, '').gsub(/\n/, '<br>')
      str += "<div class=#{type}s id=#{type}_id_#{id} style=\"display: #{display};\">#{content}</div>\n"
      id += 1
      display = 'none'
    end
    return str
  end
    
    def get_cats(cat, depth)
        if @list.include?(cat.id)
            temp = ' selected'
        end
        str = "<option value=#{cat.id}#{temp}>#{'　'*depth}#{cat.title}</option>"
        if @cat_child[cat.id]
            for item in @cat_child[cat.id]
                str += get_cats(item, depth+1)
            end
        end
        return str
    end
    
    def get_select_cat(cats)
        @list = cats.split(', ').map{|item|
            item = item.to_i
        }
    unless @cat_child
            get_cat_tree
        end
        str = '題庫：<select name=oj>'
        Category.find(:all, :conditions => 'parent = -1').each{|item|
            str += get_cats(item, 0)
        }
        str += "</select>題型：<select name=class[] multiple size=5><option value=0"
        str += " selected" if @list.length < 2
        str += ">None</option>"
        Category.find(:all, :conditions => 'parent = -2').each{|item|
            str += get_cats(item, 0)
        }
        str += '</select>'
    end

  def new_flag(prob)
    if prob.modifydate
      if Time.now - prob.modifydate < 3.day
        return '＊'
      end
    end
    return nil
  end

end
