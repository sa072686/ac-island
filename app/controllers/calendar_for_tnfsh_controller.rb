class CalendarForTnfshController < ApplicationController

  def index
    if params[:date] and params[:date] =~ /\d\d\d\d-\d\d-\d\d/
      @date = Date.parse(params[:date])
    else
      @date = Time.now
    end
    @date = @date.to_time.at_beginning_of_month.to_date
    @month = @date.month
    @year = @date.year
    @now = Time.now.to_date
  end

  def login
  end

  def logout
    session[:cal_user] = nil
    flash[:notice] = 'Logout success!!'
    redirect_to :action => 'index'
  end

  def dologin
    if request.post? and params[:username] == 'civics' and params[:password] == 'cii-vii'
      session[:cal_user] = true
      flash[:notice] = 'Login success!!'
      redirect_to :action => 'index'
    else
      flash[:notice] = 'Username or password is wrong.'
      login
      render :action => 'login'
    end
  end

  def edit
    if session[:cal_user]
      @date = params[:date]
      if @date and @date =~ /\d\d\d\d-\d\d-\d\d/
        if temp=DateForTNFSH.find_by_date(@date)
          @content = temp.note
        end
      else
        flash[:notice] = 'invalid format.'
        redirect_to :action => 'index'
      end
    else
      flash[:notice] = 'Permission denied.'
      redirect_to :action => 'index'
    end
  end

  def update
    if session[:cal_user] and request.post?
      if params[:date] and params[:date] =~ /\d\d\d\d-\d\d-\d\d/
        date = params[:date]
        if temp=DateForTNFSH.find_by_date(date)
          temp.note = params[:note]
          temp.update
        else
          temp = DateForTNFSH.new
          temp.date = date
          temp.note = params[:note]
          temp.save
        end
        flash[:notice] = 'edit success!'
        redirect_to :action => 'index', :date => date
      else
        flash[:notice] = 'invalid format.'
        redirect_to :action => 'index'
      end
    else
      flash[:notice] = 'Permission denied.'
      redirect_to :action => 'index'
    end
  end

end
