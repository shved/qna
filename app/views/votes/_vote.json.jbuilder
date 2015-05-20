json.voted_by_user @votable.voted_by?(current_user)
if @votable.has_attribute? 'question_id'
  json.type 'Answer'
  json.votable_path question_answer_path
else
  json.type 'Question'
  json.votable_path url_for(@votable)
end
json.score @votable.score
json.votable_id @votable.id
