module PermissionHelper

  def trans(bool)
    if bool
      '○'
    else
      '╳'
    end
  end

end
