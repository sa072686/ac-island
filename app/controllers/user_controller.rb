class UserController < ApplicationController

  layout 'ACIsland'
  
  before_filter :remember_url, :except => [:login, :logout, :register, :edit_user, :add_user, :update_user, :del_user, :edit_personal, :set_css]

  def index
  end

  def switch_css
    if login?
      @css_list = Css.find(:all)
      @css = Css.find_by_id(@user.css)
    else
      permission_denied
    end
  end

  def set_css
    if request.post?
      if login?
        user = User.find_by_id(@user.id)
        user.css = params[:css]
        user.save
        update_success
      else
        permission_denied
      end
    else
      go_home
    end
  end

  def userlist
    @manage = true
        @create = true
    if user_manage?
      @userlist = User.find(:all)
      @permissionlist = Permission.find(:all)
    else
      permission_denied
    end
  end

  def login
    if params[:submit]
      user = User.find_by_username(params[:username])
      if user and user.chkpwd(params[:username], params[:password])
        session[:user_id] = user.id
        flash[:notice] = '早安，'+user.username+'！'
        go_back
      else
        flash[:notice] = '帳號密碼錯誤！'
      end
    end
  end

  def logout
    if session[:user_id]
      session[:user_id] = nil
      flash[:notice] = "晚安，#{@user.username}！"
    else
      flash[:notice] = '您尚未登入！'
    end
    go_back
  end

  def register
    @create = true
  end

  def edit_personal
    if login?
      @target = @user
    else
      require_login
    end
  end

  def edit_user
    unless params[:id] and @target = User.find(params[:id])
      invalid_id
    else
      @manage = true
    end
  end

  def add_user
    if request.post?
      if user_manage? || params[:register]
        user = User.new
        user.username = params[:username]
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]
        if params[:register] || params[:permission].blank?
          user.permission = 5
        else
          user.permission = params[:permission]
        end
        user.pwd = true
        if user.save
          if params[:register]
            add_success(params[:redir], '註冊成功！')
          else
            add_success(params[:redir], '建立成功！')
          end
        else
                    unless params[:register].blank?
                        flash[:notice] = '建立新帳號失敗..'
                        userlist
                        render :action => 'userlist'
                    else
                        flash[:notice] = '註冊失敗..'
                        register
                        render :action => 'register'
                    end
          @target = user
          @create = true
        end
      else
        permission_denied
      end
    else
      go_home
    end
  end

  def update_user
    if request.post?
      if user_manage?
        if user = User.find_by_id(params[:id])
                    unless params[:new_password].blank?
              if params[:manage] || user.password == User.get_encrypted_pwd(user.username, params[:password])
                user.password = params[:new_password]
                user.password_confirmation = params[:new_password_confirmation]
                user.pwd = true
              elsif !params[:manage] and !params[:new_password].blank?
                flash[:notice] = '密碼錯誤！'
                @newuser = user
                edit_personal
                return
              end
                    end
                    if params[:manage]
                        user.permission = params[:permission] || user.permission
                    end
          if user.save
            add_success(params[:redir])
          else
            flash[:notice] = "修改失敗..#{user.pwd}"
                        if params[:manage]
                            edit_user
                            render :action => 'edit_user'
                        else
                            edit_personal
                            render :action => 'edit_personal'
                        end
            @target = user
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

    def del_user
        if request.post?
          if user_manage?
                if params[:id] and user = User.find_by_id(params[:id])
                    username = user.username
                    user.destroy
                    flash[:notice] = username+' 已被刪除！'
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

end
