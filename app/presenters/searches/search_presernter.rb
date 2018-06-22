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
          views << generate_link(result)
        end
      else
        views << "no results"
      end
      return views.join.html_safe
    end

    def generate_link(result)
      rendered_view = ""
      klass_name = result.class.to_s
      case klass_name
        when "Question"
          rendered_view = h.render(partial: 'search/questions_search_result', locals: { result: result } )
        when "Answer"
          rendered_view = h.render(partial: 'search/answers_search_result', locals: { result: result } )
        when "User"
          result.email
        when "Comment"
          if result.commentable_type == 'Question'
            rendered_view = h.render(partial: 'search/question_comments_result', locals: { result: result } )
          else
            rendered_view = h.render(partial: 'search/answer_comments_result', locals: { result: result } )
          end
      end
      rendered_view
    end
  end
end