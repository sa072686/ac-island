class SearchController < ApplicationController

  before_filter :only => :index

  layout 'ACIsland'
  helper :problem

  def index
    if params[:submit]
      @list = search_result
    end
  end

  private

  def search_result
    if params[:type] == 'problem'
      if params[:target] == 'title'
        return Problem.find(:all, :conditions => ["probid REGEXP ? or title REGEXP ?", params[:keyword], params[:keyword]])
      elsif params[:target] == 'content'
        return Problem.find(:all, :conditions => ["content REGEXP ?", params[:keyword]])
      elsif params[:target] == 'author'
        if user=User.find_by_username(params[:keyword])
          return Problem.find(:all, :conditions => ["author REGEXP ?", "(^| )#{user.id}($|,)"])
        else
          return []
        end
      else
        return []
      end
    else
      return []
    end
  end

end
