class User < ActiveRecord::Base
  has_many :votes
  has_many :voted_issues, through: :votes, source: :issue

  has_many :created_issues, foreign_key: :creator_id, class_name: 'Issue'

  attr_reader :total_vote_power

  def get_vote_power(issue_id)
    @delegate_vote = self.votes.find_by(issue_id: issue_id)
    if @delegate_vote.root?
      @total_vote_power = @delegate_vote.subtree.count
    else
      return 0
    end
  end
end
