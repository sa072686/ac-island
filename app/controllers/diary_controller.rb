class DiaryController < ApplicationController

  before_filter :remember_url, :except => [:add_diary, :update_diary, :edit_diary, :del_diary]

  layout 'ACIsland'

  def index
    make_parent_list
    @diarylist = Diary.find(:all)
    @diary = Diary.new
  end

  def add_diary
    if request.post?
      if diary_manage?
        diary = Diary.new
        diary.content = params[:content]
        diary.parent = params[:parent]
        diary.date = Time.now
        diary.author = @user.id
        if diary.save
          add_success
        else
          index
          @diary = diary
          render :action => 'index'
        end
      else
        permission_denied
      end
    else
      redirect_to '/'
    end
  end

  def update_diary
    if request.post?
      if diary_manage?
        if diary = Diary.find_by_id(params[:id])
          diary.content = params[:content]
          diary.parent = params[:parent]
          diary.date = Time.now
          diary.author = @user.id
          if diary.update
            update_success
          else
            edit_diary
            @diary = diary
            render :action => 'edit_diary'
          end
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

  def edit_diary
    if diary_manage?
      make_parent_list
      if @diary = Diary.find_by_id(params[:id])
      else
        invalid_id
      end
    else
      permission_denied
    end
  end

  def del_diary
    if request.post?
      if diary_manage?
        if temp = Diary.find_by_id(params[:id])
          temp.destroy
          go_back
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

  def make_parent_list
    @parentlist = []
    @parentlist << [0, '消息公告']
    @parentlist << [-1, '更新日誌']
  end

end
