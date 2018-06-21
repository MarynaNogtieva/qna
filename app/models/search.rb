class Search
  SEARCHING_CATEGORIES = %w[Question Answer Comment User]

  def self.search(query, search_category = nil)
    secure_query = ThinkingSphinx::Query.escape(query)
    if SEARCHING_CATEGORIES.include?(search_category)
      model = search_category.classify.constantize
      model.search secure_query
    else
      ThinkingSphinx.search secure_query
    end
  end
end

