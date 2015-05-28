json.extract! @comment, :id, :body
json.commentable @commentable.class.name.downcase
json.commentable_id @commentable.id
