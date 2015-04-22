require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:non_author) { create(:user) }
  let(:question) { create(:question) }
  let!(:files) { create_list(:attachment, 2, attachable: question) }

  context 'as an author' do
    before { sign_in question.user }

    describe 'DELETE # destroy' do
      it 'deletes files from database' do
        expect { files.each { |f| delete :destroy, id: f.id, format: :js } }
          .to change(Attachment, :count).by -2
      end

      it 'renders template destroy' do
        delete :destroy, id: files[0].id, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  context 'as a non-author' do
    before { sign_in non_author }

    describe 'DELETE #destroy' do
      it 'dont delete files from database' do
        expect { files.each { |f| delete :destroy, id: f.id, format: :js } }
          .to_not change(Attachment, :count)
      end

      it 'renders 403 error' do
        delete :destroy, id: files[0].id, format: :js
        expect(response).to be_forbidden
      end
    end
  end
end
