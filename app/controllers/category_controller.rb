class CategoryController < ApplicationController

  before_filter :remember_url, :only => 'index'

  layout 'ACIsland'

  def index
    if category_manage?
      get_tree
      @category = Category.new
    else
      permission_denied
    end
  end

  def edit_category
    if category_manage?
      get_tree
      if @category = Category.find_by_id(params[:id])
      else
        invalid_id
      end
    else
      permission_denied
    end
  end

  def add_category
    if request.post?
      if category_manage?
        cat = Category.new
        cat.title = params[:title]
        cat.parent = params[:parent]
        cat.order = params[:order]
        if cat.save
          add_success
        else
          index
          @category = cat
          flash[:notice] = '建立失敗..'
          render :action => 'index'
        end
      else
        permission_denied
      end
    else
      go_home
    end
  end

  def update_category
    if request.post?
      if category_manage?
        if cat=Category.find_by_id(params[:id])
          cat.title = params[:title]
          cat.parent = params[:parent]
          cat.order = params[:order]
          if cat.update
            update_success
          else
            edit_category
            @category = cat
            flash[:notice] = '更新失敗..'
            render :action => 'edit_category'
          end
        else
          invalid_id
        end
      else
        permission_denied
      end
    else
      go_home
    end
  end

  def del_category
    if request.post?
      if category_manage?
        if temp=Category.find_by_id(params[:id])
          temp.destroy
          destroy_success
        else
          invalid_id
        end
      else
        permission_denied
      end
    else
      go_home
    end
  end

  private

  def get_tree
    @rootlist = []
    @rootlist << [-1, '題庫']
    @rootlist << [-2, '題型']
    @list = []
    @cat_list = Category.find(:all, :conditions => 'parent < 1', :order => 'parent, `order`')
    @child = {}
    Category.find(:all, :conditions => 'parent > 0', :order => 'parent').each{|item|
      @child[item.parent.to_i] ||= []
      @child[item.parent.to_i] << item
    }
  end

end

