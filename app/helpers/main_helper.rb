module MainHelper
  def getnewlist
    if @userlist.include?(@showtype)
      @newlist = @problist - @userset[@showtype].solvedlist
    else
      @newlist = @problist
    end
    if @sortby == 'accepted'
      @newlist.sort! {|p, q| 
        if @probset[p].solvednum == @probset[q].solvednum
          @probset[p].pid.to_i <=> @probset[q].pid.to_i
        else
          @probset[q].solvednum <=> @probset[p].solvednum
        end
      }
    end
    return @newlist
  end

  def getproblink(id)
    return 'http://icpcres.ecs.baylor.edu/onlinejudge/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=' + id
  end

  def checkcomp()
    if @comp.class.to_s != 'Array' || @comp.length == 0
      return false
    end
    @comp.each{ |id|
      unless @userlist.include?(id)
        return false
      end
    }
    return true
  end

  def generatecomplist()
    @newlist = @problist - @userset[@params[:id]].solvedlist
    @newlist.delete_if {|item| 
      result = true
      for uid in @comp
        if @probset[item].getrank(uid) != -1
          result = false
          break
        end
      end
      result
    }
  end
end
