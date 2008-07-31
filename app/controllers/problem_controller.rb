class ProblemController < ApplicationController

    before_filter :remember_url, :except => [:add_problem, :update_problem, :del_problem, :edit_problem]
    before_filter :set_parent, :only => :showproblist

  layout 'ACIsland'

  def index
  end

  def showproblist
    cat = Category.find_by_title(params[:category])
    if cat
      @cat_list = []
      get_all_cat(cat)
      @title = cat.title
      @problist = Problem.find(:all).delete_if{|item|
        ((item.category || '').split(', ') & @cat_list).length == 0
      }
    elsif params[:difficulty]
      list = get_chinese_digit
      @title = '難度' + list[params[:difficulty].to_i]
      @problist = Problem.find(:all, :conditions => ["difficulty = ?", params[:difficulty]])
    else
      @title = '不正確的分類'
      @problist = []
    end
  end

  def viewproblem
    unless params[:id] and @problem=Problem.find(params[:id])
      invalid_id
    end
    @problem.hit += 1
    @problem.save
        @comment_list = Comment.find(:all, :conditions => ['parent = ?', @problem.id], :order => '`time`')
        @comment = Comment.new
        @show_comment = true
        @can_comment = comment?
  end
    
    def post_comment
        if request.post?
            if comment?
                comment = Comment.new
                comment.content = params[:content]
                comment.author = @user.id
                comment.time = Time.now
                comment.parent = params[:id]
                if comment.save
                  p = Problem.find_by_id(params[:id])
                  p.comment += 1
                  p.modifytime = Time.now
                  p.save
                    flash[:notice] = '成功發表評論！'
                    redirect_to :action => 'viewproblem', :id => params[:id]
                else
                    viewproblem
                    render :action => 'viewproblem'
                    @comment = comment
                end
            else
                permission_denied
            end
        else
            go_home
        end
    end

  def add_problem
        if request.post?
            if post?
        problem = Problem.new
        problem.probid = sprintf("%s %s", params[:proboj], params[:probid])
        problem.title = params[:title]
        author = problem.author || ''
        problem.author = (author.split(', ') | [@user.id.to_s]).join(', ')
        problem.difficulty = params[:difficulty]
        problem.category = params[:category].join(', ')
        problem.modifydate = Time.now
        problem.content = params[:content]
        problem.hint = params[:hint]
        problem.solution = params[:solution]
        problem.article = params[:article]
        problem.problem = params[:problem]
        problem.completeness = params[:completeness].join(', ')
        if params[:submit] == '送出'
        if problem.save
          add_success
        else
                    flash[:notice] = '新增失敗..'
                    go_back
        end
        else
          edit_problem
          @preview = true
          render :action => 'edit_problem'
        end
            else
                permission_denied
            end
        else
            redirect_to '/'
        end
  end

  def update_problem
        if request.post?
        if edit?
          problem = Problem.find(params[:id])
          problem.title = params[:title]
          problem.probid = sprintf("%s %s", params[:proboj], params[:probid])
          author = problem.author || ''
          problem.author = (author.split(', ') | [@user.id.to_s]).join(', ')
          problem.difficulty = params[:difficulty]
                    problem.category = params[:oj]
                    if params[:class] != ['0']
                        problem.category += ', ' + params[:class].join(', ')
                    end
          problem.modifydate = Time.now
          problem.content = params[:content]
          problem.hint = params[:hint]
          problem.solution = params[:solution]
          problem.article = params[:article]
          problem.problem = params[:problem]
          problem.completeness = params[:completeness].join(', ')
          if params[:submit] == '送出'
          if problem.update
            update_success
          else
            edit_problem
                    @problem = problem
                    render :action => 'edit_problem'
          end
          else
            edit_problem
            @problem = problem
            @preview = true
            render :action => 'edit_problem'
          end
        else
          permission_denied
        end
        else
            redirect_to '/'
        end
  end

  def edit_problem
        if post?
          @problem = Problem.new
                    @ojlist = Category.find(:all, :conditions => 'parent = -1', :order => '`order`')
            @cat = []
          if params[:id]
            @problem=Problem.find(params[:id])
            @cat = @problem.category.split(', ') || []
            if @problem.completeness
              @completeness = @problem.completeness.split(', ')
            else
              @completeness = ['0', '0', '0', '0']
            end
            list = @problem.probid.split(' ')
            @oj = list[0]
            @id = list[1]
          else
            @completeness = ['0', '0', '0', '0']
          end
        else
          permission_denied
        end
  end

  def del_problem
        if request.post?
        if del?
          if problem=Problem.find(params[:id])
            problem.destroy
            destroy_success
          else
            invalid_id
          end
        else
          permission_denied
        end
        else
            redirect_to '/'
        end
  end

  private

  def set_parent
    cookies[:set_parent] = request.request_uri
  end

  def get_all_cat(item)
    @cat_list << item.id.to_s
    Category.find(:all, :conditions => 'parent = '+item.id.to_s).each{|item|
      get_all_cat(item)
    }
  end

end
