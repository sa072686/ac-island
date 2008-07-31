class AdminController < ApplicationController

  before_filter :remember_url, :only => ['index', 'admin_css']

  layout 'ACIsland'

  Path = '/home/sa072686/ACM/ACMSA/public/'
  FPath = '/home/sa072686/public_html/forACMSA/'

  def index
    @list = []
    if edit_css?
      @list << ['管理 CSS', '/admin/admin_css']
    end
    if edit_javascript?
      @list << ['編輯 JavaScript', '/admin/edit_javascript']
    end
    if user_manage?
      @list << ['管理使用者', '/user/userlist']
    end
    if permission_manage?
      @list << ['管理權限群組', '/permission']
    end
    if menu_manage?
      @list << ['管理選單項目', '/menu']
    end
    if diary_manage?
      @list << ['管理日誌', '/diary']
    end
    if category_manage?
      @list << ['管理分類', '/category']
    end
  end

  def edit_css_content
    if edit_css?
      if c=Css.find_by_id(params[:id])
        @id = c.id
        fp = get_fp(c.fname)
        check_css_file(fp)
        unless params[:submit].blank?
          if request.post?
            f = File.open(fp, "w")
            f.write(params[:content])
            f.close
            flash[:notice] = '修改成功！'
          else
            go_home
          end
        end
        f = File.open(fp, "r")
        @content = f.read
        f.close
      else
        invalid_id
      end
    else
      permission_denied
    end
  end

  def admin_css
    if edit_css?
      @css_list = Css.find(:all)
      @css = Css.new
    else
      permission_denied
    end
  end

  def add_css
    if edit_css?
      if request.post?
        fp = get_fp(params)
        c = Css.new
        c.name = params[:name]
        c.fname = params[:fname]
        if c.save
          fp = get_fp(c.fname)
          check_css_file(fp)
          add_success
        else
          admin_css
          @css = c
          render :action => 'admin_css'
        end
      else
        go_home
      end
    else
      permission_denied
    end
  end

  def update_css
    if edit_css?
      if request.post?
        if c=Css.find_by_id(params[:id])
          c.name = params[:name]
          c.fname = params[:fname]
          if c.save
            fp = get_fp(c.fname)
            check_css_file(fp)
            update_success
          else
            edit_css
            @css = c
            render :action => 'edit_css'
          end
        else
          invalid_id
        end
      else
        go_home
      end
    else
      permission_denied
    end
  end

  def edit_css
    if edit_css?
      if @css=Css.find_by_id(params[:id])
      else
        invalid_id
      end
    else
      permission_denied
    end
  end

  def del_css
    if edit_css?
      if request.post?
        if c=Css.find_by_id(params[:id])
          c.destroy
          destroy_success
        else
          invalid_id
        end
      else
        go_home
      end
    else
      permission_denied
    end
  end

  def edit_javascript
    if edit_javascript?
      if request.post? and params[:content]
        File.open(Path+'javascripts/ACIsland.js', 'w'){|f|
          f.write(params[:content])
        }
        flash[:notice] = '修改成功！'
      end
      File.open(Path+'javascripts/ACIsland.js', 'r'){|f|
        @content = f.read
      }
    else
      permission_denied
    end
  end

  def generate_ACM_problem
    f = File.open(FPath+'problist.txt', 'r')
    flash[:notice] = ''
    f.each{|line|
      list = line.split('_')
      id = list[1]
      title = list[2]
      probid = 'ACM '+id
      cat = Category.find_by_title(s='ACM Volume '+get_roman_number(id.to_i / 100))
      unless cat
        flash[:notice] << 'Creating Category::'+s+'..'
        cat = Category.new
        cat.title = s
        parent = Category.find_by_title('ACM')
        unless parent
          flash[:notice] << 'Creating Category::ACM..'
          parent = Category.new
          parent.title = 'ACM'
          parent.parent = -1
          parent.order = 0
          parent.save
        end
        cat.parent = parent.id.to_s
        cat.order = (id.to_i / 100) * 100
        cat.save
      end
      if problem = Problem.find_by_probid('ACM '+id)
      else
        problem = Problem.new
        problem.probid = probid
        problem.title = title
        problem.author = ''
        problem.difficulty = 0
        problem.category = cat.id.to_s
        problem.modifydate = ''
        problem.content = ''
        problem.hint = ''
        problem.solution = ''
        problem.article = ''
        problem.problem = ''
        problem.completeness = '0, 0, 0, 0'
        problem.save
      end
    }
    redirect_to :controller => 'home'
  end

  def generate_TIOJ_problem
    f = File.open(FPath+'TIOJ.txt', 'r')
    flash[:notice] = ''
    f.each{|line|
      list = line.split('::_')
      id = list[0]
      title = list[1]
      probid = 'TIOJ '+id
      vol = id.to_i / 100 - 9
      cat = Category.find_by_title(s='TIOJ Volume '+vol.to_s)
      unless cat
        cat = Category.new
        cat.title = s
        parent = Category.find_by_title('TIOJ')
        unless parent
          parent = Category.new
          parent.title = 'TIOJ'
          parent.parent = -1
          parent.order = 200
          parent.save
        end
        cat.parent = parent.id.to_s
        cat.order = vol * 100
        cat.save
      end
      if problem = Problem.find_by_probid('TIOJ '+id)
      else
        problem = Problem.new
        problem.probid = probid
        problem.title = title
        problem.author = ''
        problem.difficulty = 0
        problem.category = cat.id.to_s
        problem.modifydate = ''
        problem.content = ''
        problem.hint = ''
        problem.solution = ''
        problem.article = ''
        problem.problem = ''
        problem.completeness = '0, 0, 0, 0'
        problem.save
      end
    }
    redirect_to :controller => 'home'
  end

  def generate_USACO_problem
    f = File.open(FPath+'USACO.txt', 'r')
    f.each{|line|
      list = line.split('::')
      id = list[0]
      type = list[1]
      title = list[2]
      probid = 'USACO '+id
      cat = Category.find_by_title(s="USACO Chapter #{id[0]-48}")
      unless cat
        cat = Category.new
        cat.title = s
        parent = Category.find_by_title('USACO')
        unless parent
          parent = Category.new
          parent.title = 'USACO'
          parent.parent = -1
          parent.order = 400
          parent.save
        end
        cat.parent = parent.id.to_s
        cat.order = (id[0]-48) * 100
        cat.save
      end
      if problem = Problem.find_by_title(title)
      else
        if type == 'PROB'
          problem = Problem.new
          problem.probid = probid
          problem.title = title
          problem.author = ''
          problem.difficulty = 0
          problem.category = cat.id.to_s
          problem.modifydate = ''
          problem.content = ''
          problem.hint = ''
          problem.solution = ''
          problem.article = ''
          problem.problem = ''
          problem.completeness = '0, 0, 0, 0'
          problem.save
        end
      end
    }
    redirect_to :controller => 'home'
  end

  def generate_Ural_problem
    f = File.open(FPath+'Ural.txt', 'r')
    f.each{|line|
      list = line.split('::_')
      id = list[0]
      title = list[1]
      probid = 'Ural '+id
      vol = id.to_i / 100 - 9
      cat = Category.find_by_title(s='Ural Volume '+vol.to_s)
      unless cat
        cat = Category.new
        cat.title = s
        parent = Category.find_by_title('Ural')
        unless parent
          parent = Category.new
          parent.title = 'Ural'
          parent.parent = -1
          parent.order = 800
          parent.save
        end
        cat.parent = parent.id.to_s
        cat.order = vol * 100
        cat.save
      end
      if problem = Problem.find_by_probid('Ural '+id)
      else
        problem = Problem.new
        problem.probid = probid
        problem.title = title
        problem.author = ''
        problem.difficulty = 0
        problem.category = cat.id.to_s
        problem.modifydate = ''
        problem.content = ''
        problem.hint = ''
        problem.solution = ''
        problem.article = ''
        problem.problem = ''
        problem.completeness = '0, 0, 0, 0'
        problem.save
      end
    }
    redirect_to :controller => 'home'
  end

  def migrate_submenu
    catlist = Category.find(:all, :conditions => "title REGEXP ' '")
    for cat in catlist
      unless Menu.find(:first, :conditions => "url REGEXP '#{cat.title}'")
        menu = Menu.new
        menu.title = get_simple_volume(cat.title)
        menu.url = "/problem/showproblist?category=#{cat.title}"
        menu.parent = Menu.find_by_title(cat.title.split(' ')[0]).id
        menu.order = cat.order
        menu.save
      end
    end
    redirect_to :controller => 'home'
  end

  def del_trailing_space
    Menu.find(:all).each{|item|
      if item.title[0] == 32
        item.title = item.title.from(1)
        item.update
      end
    }
    redirect_to 'home'
  end

  def generate_difficulty
    ary = get_chinese_digit
    for diff in 1..10
      title = '難度' + ary[diff]
      unless Menu.find_by_title(title)
        menu = Menu.new
        menu.title = title
        menu.url = "/problem/showproblist?difficulty="+diff.to_s
        menu.parent = Menu.find_by_title('依難度').id
        menu.order = diff * 100
        menu.save
      end
    end
    redirect_to :controller => 'home'
  end

  private

  def get_fp(fname)
    fp = Path + "stylesheets/#{fname}.css"
  end

  def check_css_file(fp)
    unless File.exist?(fp)
      f = File.new(fp, "w")
      f.write("\n")
      f.close
    end
  end

end
