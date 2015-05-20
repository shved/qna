json.extract! @answer, :id, :body
json.path question_answer_path(@answer.question, @answer)
json.attachments @answer.attachments do |a|
  json.id a.id
  json.url a.file.url
end
