class MenuController < ApplicationController

    before_filter :remember_url, :except => [:add_menu, :edit_menu, :update_menu, :del_menu]

  layout 'ACIsland'

  def index
    if menu_manage?
      @list = []
      @menulist = Menu.find(:all, :order => '`order`')
      @children = {}
      @hash = {}
      @menulist.each {|item|
        @hash[item.id] = item
        unless @children[p=item.parent.to_i]
          @children[p] = []
        end
        @children[p] << item
      }
    else
      permission_denied
    end
  end

  def add_menu
        if request.post?
        if menu_manage?
          menu = Menu.new
          menu.title = params[:title]
          menu.url = params[:url]
          menu.parent = params[:parent]
          menu.order = params[:order]
          if menu.save
            add_success('/menu')
          else
            redirect_to '/'
          end
        else
          permission_denied
        end
        else
            redirect_to '/'
        end
  end

  def edit_menu
    index
    if menu_manage?
      unless @menu=Menu.find(params[:id])
        invalid_id
      end
    else
      permission_denied
    end
  end

  def update_menu
        if request.post?
        if menu_manage?
          if menu=Menu.find(params[:id])
            menu.title = params[:title]
            menu.parent = params[:parent]
            menu.url = params[:url]
            menu.order = params[:order]
            if menu.update
              update_success('/menu')
            else
              update_fail('/menu')
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

  def del_menu
        if request.post?
        if menu_manage?
          if menu=Menu.find(params[:id])
            menu.destroy
            destroy_success('/menu')
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

end
