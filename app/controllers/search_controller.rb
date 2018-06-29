# require '/Users/mnogtieva/Learning/thinknetica/qna/app/presenters/searches/search_presernter.rb'
require "#{Rails.root}/app/presenters/searches/search_presernter.rb" 
class SearchController < ApplicationController
  skip_authorization_check 
  def search
    @search_results = Search.search(params[:search][:query], params[:search][:category])  if params[:search][:query].present?
  end
end