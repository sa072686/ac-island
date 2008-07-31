# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_ACMSA_session_id'

  before_filter :clear_session
  before_filter :set_menu_status
  before_filter :getuser
  before_filter :makemenu
  before_filter :check_letter
  before_filter :get_css_file

  Path = '../../public_html/forACMSA/'
  Menupath = '/home/sa072686/'
  Splitchar = '_'
  Menu_class = 'menu_class_'
  Menu_id = 'menu_id_'
  Session_expire = 4.hour

  private

  def get_chinese_digit
    return ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十']
  end

  def set_roman_digit
    @roman_digit = [['', 'M', 'MM', 'MMM', '', '', '', '', '', ''], 
                    ['', 'C', 'CC', 'CCC', 'CD', 'D', 'DC', 'DCC', 'DCCC', 'CM'], 
                    ['', 'X', 'XX', 'XXX', 'XL', 'L', 'LX', 'LXX', 'LXXX', 'XC'], 
                    ['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX']]
  end

  def set_roman_number
    unless @roman_digit
      set_roman_digit
    end
    @roman_number = []
    for num in 1...4000
      temp = sprintf("%04d", num)
      str = ''
      for dig in 0...4
        str += @roman_digit[dig][temp[dig].to_i-48]
      end
      @roman_number[num] = str
    end
  end

  def get_roman_number(number)
    if number > 0 and number < 4000
      unless @roman_digit
        set_roman_digit
      end
      temp = sprintf("%04d", number)
      str = ''
      for dig in 0...4
        str += @roman_digit[dig][temp[dig].to_i-48]
      end
    else
      return '0'
    end
  end

  def get_simple_volume(title)
    if loc=title.index(' ')
      return title.from(title.index(' ')+1)
    else
      return title
    end
  end
  
  def remember_url
    session[:orig_url] = request.request_uri
  end

  def destroy_success(url=nil, message=nil)
    flash[:notice] = message || '成功刪除！'
    redirect_to url || session[:orig_url] || '/'
  end

  def invalid_id(url=nil, message=nil)
    flash[:notice] = message || '不正確的 ID！'
    redirect_to url || session[:orig_url] || '/'
  end

  def permission_denied(url='/', message=nil)
    flash[:notice] = message || '權限不足！'
    redirect_to url || session[:orig_url] || '/'
  end

  def require_login(url='/user/login', message=nil)
    flash[:notice] = message || '尚未登入！'
    redirect_to url
  end

  def add_success(url=nil, message=nil)
    flash[:notice] = message || '新增成功！'
    redirect_to url || session[:orig_url] || '/'
  end

  def update_success(url=nil, message=nil)
    flash[:notice] = message || '修改成功！'
    redirect_to url || session[:orig_url] || '/'
  end
  
  def god?
        return @user.god?
  end
  
  def post?
        return @user.god? || @user.post?
  end
  
  def edit?
        return @user.god? || @user.edit?
  end
  
  def del?
        return @user.god? || @user.del?
  end
  
  def comment?
        return @user.god? || @user.comment?
  end
  
  def edit_css?
        return @user.god? || @user.edit_css?
  end
  
  def edit_javascript?
        return @user.god? || @user.edit_javascript?
  end
  
  def category_manage?
        return @user.god? || @user.category_manage?
  end
  
  def user_manage?
        return @user.god? || @user.user_manage?
  end
  
  def permission_manage?
        return @user.god? || @user.permission_manage?
  end
  
  def menu_manage?
        return @user.god? || @user.menu_manage?
  end
  
  def diary_manage?
        return @user.god? || @user.diary_manage?
  end
  
  def mail_manage?
        return @user.god? || @user.mail_manage?
  end
  
  def view_statistics?
        return @user.god? || @user.view_statistics?
  end
  
  def edit_page?
        return @user.god? || @user.edit_page?
  end

  def announce?
    return @user.god? || @user.announce?
  end

  def getlink(title, url)
    sprintf("<a href=\"%s\">%s</a>", url, title)
  end
    
    def get_breakline_link(title, url)
        sprintf("　<a href=\"%s\">%s</a><br>", url, title)
    end
  
  def go_back()
        redirect_to session[:orig_url] || '/'
  end

  def go_home()
    redirect_to '/'
  end

  def getuserhash
    hash = {}
    User.find(:all).each{|user|
      hash[user.id.to_s] = user
    }
    return hash
  end

  def makemenu
    topmenu = Menu.find(:all, :conditions => 'parent = 0').map{|item|
      [item.title, item.url]
    }
    if login?
      if post?
        topmenu << ['管理頁面', '/admin']
      end
      topmenu << ['個人資訊', '/user']
      topmenu << ['登出', '/user/logout']
    else
      topmenu << ['登入', '/user/login']
    end
    @topmenu = topmenu.map{|item|
      getlink(item[0], item[1])
    }.join(' | ')
    item = Menu.find(:first, :conditions => 'title = "'+controller_name+'" and parent = -1')
    @jsmenu_id = 0
    @leftmenu = get_submenu(item, -1)
  end
    
    def ishidden(bool)
        if bool
            return 'block'
        else
            return nil
        end
    end
    
    def set_menu_status
        if type=params[:type] and id=params[:menu_id]
            if type == '0'
                session[id] = true
            elsif type == '1'
                session[id] = nil
            end
        end
    end
    
    def get_menu_status(bool)
        if bool
            return 1
        else
            return 0
        end
    end

  def get_menu_link(title, url, depth)
    url ||= ''
    req_url = request.request_uri.gsub(/[\&\?]type=.+/, '')
    if req_url.index('?')
      req_url += '&'
    else
      req_url += '?'
    end
    s = "<div id=#{Menu_id+@jsmenu_id.to_s} class=list_depth#{depth}>"
    @jsmenu_id += 1
    if temp=session[name=Menu_id+@jsmenu_id.to_s]
      par = "type=1&menu_id=#{name}"
      syn = '－'
    else
      par = "type=0&menu_id=#{name}"
      syn = '＋'
    end
    s += "<a href='#{req_url+par}'>#{syn}</a>"
    s += "<a href='#{url}'>#{title}</a><br>"
    s += "</div><div id=#{Menu_id+@jsmenu_id.to_s} class=list_all_depth style='display: #{ishidden(temp)}'>"
    @jsmenu_id += 1
    return s
  end

  def get_submenu(item, depth)
    unless item
      return '<fieldset><legend>空白</legend>此頁面無子選單</fieldset>'
    end
    menulist = Menu.find(:all, :conditions => 'parent = '+item.id.to_s, :order => '"order"')
    if depth == -1
      str = '<fieldset><legend>'+(item.url || '')+'</legend><div id="problist_menu">'
    else
      if menulist.length == 0
        str = get_breakline_link(item.title, item.url)
      else
        str = get_menu_link(item.title, item.url, depth)
      end
    end
    menulist.each{|item|
      str += get_submenu(item, depth+1)
    }
    if depth == -1
      str += '</div></fieldset>'
    elsif menulist.length > 0
      str += '</div>'
    end
    return str
  end

  def get_jsmenu_link(title, depth)
    s = "<div id=#{Menu_id+@jsmenu_id.to_s} class=list_depth#{depth}><a href=\"javascript: clickNode('#{Menu_id+@jsmenu_id.to_s}',"
    @jsmenu_id += 1
    s += "'#{Menu_id+@jsmenu_id.to_s}',#{depth})\">#{title}</a></div><div id=#{Menu_id+@jsmenu_id.to_s} class=list_all_depth>"
    @jsmenu_id += 1
    return s
  end

  def get_js_submenu(item, depth)
    unless item
      return '未定義的選單'
    end
    menulist = Menu.find(:all, :conditions => 'parent = '+item.id.to_s, :order => '"order"')
    if depth == -1
      str = '<fieldset><legend>'+(item.url || '')+'</legend><div id="problist_menu">'
    else
      if menulist.length == 0
        str = getlink(item.title, item.url)
      else
        str = get_jsmenu_link(item.title, depth)
      end
    end
    menulist.each{|item|
      str += getsubmenu(item, depth+1)
    }
    if depth == -1
      str += '</div></fieldset>'
    elsif menulist.length > 0
      str += '</div>'
    end
    return str
  end

  def login?
    return @user.username
  end


  def getuser
    unless session[:user_id] and @user=User.find(session[:user_id])
      @user = User.new
    end
  end

  def build
    @userset = Hash.new
    @usernum = 0
    @userlist = Array.new
    @probset = Hash.new
    @probnum = 0
    @problist = Array.new
    File.open(Path + 'problist.txt', 'r').each { |line|
      @probnum += 1
      temp = line.split(Splitchar)
      problem = Problem.new
      problem.id = temp[0]
      problem.pid = temp[1]
      problem.title = temp[2]
      @problist << problem.pid
      @probset[problem.pid] = problem
    }
    File.open(Path + 'user.txt', 'r').each { |line|
      temp = line.split(':')
      id = temp[0]
      unless File.exist?(Path + 'author/' + id + '.txt')
        next
      end
      @usernum += 1
      user = User.new
      user.acmid = temp[0]
      user.name = temp[1]
      @userlist << user.acmid
      data = File.open(Path + 'author/' + user.acmid + '.txt', 'r')
      temp = data.gets
      temp = temp.split(Splitchar)
      user.submission = temp[0].to_i
      user.triednum = temp[1].to_i
      user.solvednum = temp[2].to_i
      while line = data.gets
        temp = line.split(Splitchar)
        pid = temp[0]
        rank = temp[1]
        date = temp[2]
        cputime = temp[3]
        unless @probset[pid]
          render :text => pid
          return
        end
        @probset[pid].solvedlist << {'name'=>user.name, 'id'=>user.acmid, 'rank'=>rank, 'date'=>date, 'cputime'=>cputime}
        @probset[pid].solvednum += 1
        user.solvedlist << pid
      end
      @userset[user.acmid] = user
      data.close
    }
    @userlist.sort!{ |p, q|
      if @userset[p].solvednum == @userset[q].solvednum
        if @userset[p].triednum == @userset[q].triednum
          @userset[p].submission <=> @userset[q].submission
        else
          @userset[p].triednum <=> @userset[q].triednum
        end
      else
        @userset[q].solvednum <=> @userset[p].solvednum
      end
    }
    for id in @problist
      if @probset[id].solvednum > 1
        @probset[id].solvedlist.sort!{ |p, q|   
          p['rank'].to_i <=> q['rank'].to_i
        }
      end
    end
  end

  def clear_session
    now = Time.now
    Session.find(:all).each{|s|
      s.destroy if now - s.updated_at > Session_expire
    }
  end

  def check_letter
    if login?
      list = Letter.find(:all, :conditions => ['receiver = ? AND `read` = 0', @user.id])
      if list.length > 0
        flash[:letter] = "您有未讀信件！！"
      end
    end
  end

  def do_announce(title, content, namelist=nil)
    namelist ||= User.find(:all).map {|item|
      item.username
    }.join(', ')
    flash[:notice] = ''
    namelist.split(', ').each{|item|
      if user = User.find_by_username(item)
        l = Letter.new
        l.title = title
        l.receiver = user.id
        l.content = content
        l.author = @user.id
        l.read = false
        l.save
        flash[:notice] += "已順利對 #{item} 送出通知。<br>"
      else
        flash[:notice] += "使用者 #{item} 不存在。<br>"
      end
    }
  end

  def get_css_file
    if css = Css.find_by_id(@user.css)
      @css_file_name = "#{css.fname}.css"
    else
      @css_file_name = "ACIsland.css"
    end
  end

end
