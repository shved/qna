class RemoveScoreFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :score, :integer
  end
end
