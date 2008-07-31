module LocalLetterHelper

  def get_letter_link(text, id)
    return link_to text, :controller => 'local_letter', :action => 'view_letter', :id => id
  end

  def unread_note
    return '(new)'
  end

  def get_letter_content(content)
    content = content.gsub("\n", "<br>")
  end

end
