require_relative 'features_helper'

feature 'Delete files attached to question', %q{
  As a question author
  I want to be able to delete files attached to question
}, type: :feature do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, :with_files, question: question) }
  given(:author) { answer.user }

  scenario 'Author deletes multiple files from his answer', js: true do
    filenames = answer.attachments.pluck(:file)
    sign_in author
    visit question_path question

    click_on 'Edit answer'
    click_on 'Delete file', match: :first
    click_on 'Delete file'
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content filenames[0]
    expect(page).to_not have_content filenames[1]
  end

  scenario 'Author deletes one file from his answer', js: true do
    filenames = answer.attachments.pluck(:file)
    sign_in author
    visit question_path question

    click_on 'Edit answer'
    click_on 'Delete file', match: :first
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content filenames[0]
  end
end
