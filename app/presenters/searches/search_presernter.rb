module Searches
  class SearchPresenter
    def initialize(search_results, view)
    @search_results, @view = search_results, view
    end

    def h
      @view
    end

    def render_results
      views = []
      if @search_results.present?
        @search_results.each do |result|
          byebug
          views << generate_link(result)
        end
      else
        views << "no results"
      end
      return views.join.html_safe
    end

    def generate_link(result)
      rendered_view = ""
      case result.class
      when Question
        rendered_view = h.render(partial: 'search/questions_search_result', locals: { result: result } )
      when Answer
         @view.link_to result.body, result.question
      when User
        result.email
      when Comment
        if result.commentable_type == 'Question'
           @view.link_to result.body, question_path(result.commentable_id)
        else
          @view.link_to result.body, question_path(result.commentable.question)
        end
      end
      rendered_view
    end
  end
end