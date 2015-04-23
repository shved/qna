require_relative 'features_helper'

feature 'Delete files attached to question', %q{
  As a question author
  I want to be able to delete files attached to question
}, type: :feature do
  given(:question) { create(:question, :with_files) }
  given(:author) { question.user }

  scenario 'Author deletes multiple files from his question', js: true do
    filenames = question.attachments.pluck(:file)
    sign_in author
    visit question_path question

    click_on 'Edit question'
    click_on 'Delete file', match: :first
    click_on 'Delete file'
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content filenames[0]
    expect(page).to_not have_content filenames[1]
  end

  scenario 'Author deletes one file from his question', js: true do
    filenames = question.attachments.pluck(:file)
    sign_in author
    visit question_path question

    click_on 'Edit question'
    click_on 'Delete file', match: :first
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content filenames[0]
  end
end
