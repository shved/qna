class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :votable_type, inclusion: ['Question', 'Answer']
  validates :value, inclusion: [-1, 1]
end
