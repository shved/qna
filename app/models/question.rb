class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  include Votable

  validates :title, presence: true, length: { in: 15..150 }
  validates :body, presence: true, length: { in: 30..1000 }
  validates :user_id, presence: true

  validates_associated :user

  accepts_nested_attributes_for :attachments, reject_if: lambda { |a| a[:file].blank? }, allow_destroy: true
end
