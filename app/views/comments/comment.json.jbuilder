json.extract! @comment, :id, :body
json.parent @commentable.class.name.downcase
json.parent_id @commentable.id
