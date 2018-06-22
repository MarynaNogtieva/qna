require '/Users/mnogtieva/Learning/thinknetica/qna/app/presenters/searches/search_presernter.rb'
class SearchController < ApplicationController
  skip_authorization_check 
  def search
    result = Search.search(params[:search][:query], params[:search][:category])
    @search_results = ::Searches::SearchPresenter.new(result, view_context)
    # respond_with(@search_results)
  end
end