require 'digest/sha1'

class User < ActiveRecord::Base

  attr_accessor :pwd

  validates_length_of :username, :in => 2..14
  validates_format_of :username, :with => /^[a-zA-Z0-9_]+$/, :message => "只能是英文字母、數字與底線。"
  validates_uniqueness_of :username, :case_sensitive => false, :message => '不得與它人重覆。'
  validates_length_of :password, :in => 2..14, :if => :chkpwd?
  validates_confirmation_of :password, :if => :chkpwd?
  validates_numericality_of :permission

  def validate
    unless self.permission and Permission.find_by_id(self.permission)
      errors.add(:permission, '為不存在的權限。')
    end
  end

  def chkpwd?
    return @pwd
  end
    
    def get_permission
        unless self.permission and @permission = Permission.find_by_id(self.permission)
            @permission = Permission.new
            @permission.title = '訪客'
        end
    end

  def god?
        get_permission
    @permission.god?
  end

  def post?
        get_permission
    @permission.post?
  end

  def edit?
        get_permission
    @permission.edit?
  end

  def del?
        get_permission
    @permission.delete?
  end

  def comment?
        get_permission
    @permission.comment?
  end
  
  def edit_css?
        get_permission
    @permission.edit_css?
  end
  
  def edit_javascript?
        get_permission
    @permission.edit_javascript?
  end
  
  def category_manage?
        get_permission
    @permission.category_manage?
  end
  
  def user_manage?
        get_permission
    @permission.user_manage?
  end
  
  def permission_manage?
        get_permission
    @permission.permission_manage?
  end
  
  def menu_manage?
        get_permission
    @permission.menu_manage?
  end
  
  def diary_manage?
        get_permission
    @permission.diary_manage?
  end
  
  def mail_manage?
        get_permission
    @permission.mail_manage?
  end
  
  def view_statistics?
        get_permission
    @permission.view_statistics?
  end
  
  def edit_page?
        get_permission
    @permission.edit_page?
  end

  def chkpwd(usr, pwd)
    return User.get_encrypted_pwd(usr, pwd) == self.password
  end

  protected

  def self.get_encrypted_pwd(usr, pwd)
    return Digest::SHA1.hexdigest(usr.downcase+' AC '+pwd+' Island!!!!')
  end
  
  def before_save
        if chkpwd?
            self.password = User.get_encrypted_pwd(self.username, self.password)
        end
  end

end
