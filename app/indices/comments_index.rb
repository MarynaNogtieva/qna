ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes body
  indexes user.email, as: :author, sortable: true

  # attributes -group, sort, search
  has user_id, created_at, updated_at
end
