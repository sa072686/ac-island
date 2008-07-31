module DocumentHelper

	def get_doc_list
		str = ''
		for item in @doc_list
			str += link_to(item[0], :action => item[1]) + '<br>'
		end
		return str
	end

end
