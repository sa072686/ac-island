class LocalLetterController < ApplicationController

  before_filter :remember_url, :except => ['send_letter', 'del_letter']

  layout 'ACIsland'

  def index
    if login?
      @list = Letter.find(:all, :conditions => ['receiver = ?', @user.id], :order => '`created_at` DESC')
    else
      permission_denied
    end
    @let = Letter.new
  end

  def announce
    if announce?
      unless params[:submit].blank?
        if params[:receiver].blank?
          do_announce(params[:title], params[:content])
        else
          do_announce(params[:title], params[:content], params[:receiver])
        end
      end
    else
      permission_denied
    end
  end

  def view_letter
    if login?
      if @letter = Letter.find_by_id(params[:id]) and @letter.receiver == @user.id
        @letter.read = true
        @letter.save
        @let = Letter.new
        @let.title = get_reply_title(@letter.title)
        u = User.find_by_id(@letter.author)
        if u
          u = u.username
        else
          u = '不存在的使用者'
        end
        @let.receiver = @letter.author
        @rec = u
        @let.content = get_reply_content(@letter.content, u)
      else
        invalid_id
      end
    else
      permission_denied
    end
  end

  def send_letter
    if login?
      f = false
      flash[:notice] = ''
      temp = nil
      params[:receiver].split(', ').each {|item|
        unless rec = User.find_by_username(item)
          flash[:notice] += "使用者 #{item} 不存在。<br>"
          f = true
          next
        end
        letter = Letter.new
        letter.title = params[:title]
        letter.content = params[:content]
        letter.author = @user.id
        letter.receiver = rec.id
        letter.read = false
        if letter.save
          flash[:notice] += "給 #{item} 的信已寄送成功。<br>"
        else
          f = true
          temp = letter
        end
      }
      if f
        index
        @let = temp
        @let.title = params[:title]
        @let.content = params[:content]
        @rec = @let.receiver = params[:receiver]
        render :action => 'index'
      else
        add_success
      end
    else
      permission_denied
    end
  end

  def del_letter
    if login?
      if letter = Letter.find_by_id(params[:id])
        letter.destroy
        destroy_success
      else
        invalid_id
      end
    else
      permission_denied
    end
  end

  private

  def get_reply_title(title)
    if title.match(/^回覆：/)
      return title
    else
      return "回覆：#{title}"
    end
  end

  def get_reply_content(content, name)
    return "引述 #{name} 的名言：\n#{content}"
  end

end
