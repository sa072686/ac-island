class MainController < ApplicationController

  before_filter :build, :except => [:unknown, :randomg]
  before_filter :randomg, :only => :personal

  layout 'main'

  def index
  end

  def showproblist
  end

  def problem
  end

  def personal
  end

  def random
  end

  def about
  end

  def unknown
  end

  def randomg
    if @params[:submit] && @params[:submit] == 'random generate' && @params[:comp].class.to_s == 'Array'
      redirect_to '/main/random/' + @params[:id] + '?comp[]=' + @params[:comp].join('&comp[]=')
    end
  end

end
