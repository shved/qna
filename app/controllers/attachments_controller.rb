class AttachmentsController < ApplicationController
  before_action :authenticate_user!, :check_authorship

  respond_to :js

  authorize_resource

  def destroy
    @attachment.destroy
    respond_with(@attachment)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def load_parent
    load_attachment
    parent_type = @attachment.attachable_type
    parent_id = @attachment.attachable_id
    @parent = parent_type.constantize.find(parent_id)
  end

  def check_authorship
    load_parent
    if @parent.user_id != current_user.id
      render status: 403, text: 'Only author can delete this file'
    end
  end
end
