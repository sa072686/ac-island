module CalendarForTnfshHelper

  def link_to_last
    link_to 'last month', :action => 'index', :date => @date.to_time.last_month.to_date.to_s(:db)
  end
  
  def link_to_next
    link_to 'next month', :action => 'index', :date => @date.to_time.next_month.to_date.to_s(:db)
  end

  def get_all_events
    str = ''
    weekname = ['日', '一', '二', '三', '四', '五', '六']
    @date.step(@date+Time.days_in_month(@month, @year)-1, 1) {|item|
      str += "<tr><td>#{item.to_s(:db)}</td><td>#{weekname[item.wday]}</td><td>"
      if temp=DateForTNFSH.find_by_date(item.to_s(:db))
        str += temp.note
      else
        str += '&nbsp;'
      end
      str += "</td>"
      if @session[:cal_user]
        str += "<td>"+link_to('編輯', :action => 'edit', :date => item.to_s(:db))+"</td>"
      end
      str += "</tr>"
    }
    return str
  end

end
