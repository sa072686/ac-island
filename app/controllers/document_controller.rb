class DocumentController < ApplicationController

	before_filter :remember_url

	layout 'ACIsland'

	def index
		@doc_list = []
		@doc_list << ["編輯說明", 'edit_problem']
		@doc_list << ["注意事項", 'notice']
		@doc_list << ["管理說明", 'admin']
	end
	
	def edit_problem
	end
	
	def notice
	end
	
	def admin
	end

end
