class HomeController < ApplicationController

  before_filter :remember_url

  layout 'ACIsland'

  helper :problem

  def index
  end

  def news
    @url = request.request_uri
    @title = '消息公告'
    @diarylist = Diary.find(:all, :conditions => 'parent = 0', :order => 'date DESC')
    if params[:all]
      @limit = @diarylist.length
    else
      @limit = [50, @diarylist.length].min
    end
  end

  def whatsnew
    @problist = Problem.find(:all, :order => '`modifydate` DESC', :limit => 100).delete_if{|item|
      item.modifydate.blank?
    }
  end

  def diary
    @url = request.request_uri
    @title = '更新日誌'
    @diarylist = Diary.find(:all, :conditions => 'parent = -1', :order => 'date DESC')
    if params[:all]
      @limit = @diarylist.length
    else
      @limit = [50, @diarylist.length].min
    end
    render :action => 'news'
  end

  def about
  end

  def intro
  end
    
    def unknown
    end

end
