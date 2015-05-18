json.extract! @answer, :id, :body, :best
json.path question_answer_path(@answer.question, @answer)
json.attachments @answer.attachments do |a|
  json.id a.id
  json.filename a.file.filename
  json.url a.file.url
end
