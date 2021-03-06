class IssuesController < ApplicationController
  def index
    @issues = Issue.all
  end

  def show
    @current_issue = Issue.find(params[:id])
    p @current_issue
  end

  def vote
    # p "Got here!"
    # p params
    @vote = current_user.votes.find_by(issue_id: params[:id])

    if @vote.root?
      @vote.update_attributes(value: params[:value])
      @vote.save
    else
      puts "User has delegated their vote."
    end

    @vote.descendants.each do |vote|
      vote.value = @vote.value
      vote.save
    end

    render json: @vote
  end

  def delegate
    @representative = User.find(params[:id])
    @representative_vote = @representative.votes.find_by(issue_id: params[:issue_id])

    @current_user_vote = current_user.votes.find_by(issue_id: params[:issue_id])

    @current_user_vote.parent = @representative_vote
    @current_user_vote.save

    p @representative_vote.descendants
    # @delegate_vote.descendants.each do |vote|
    #   vote.value = @delegate_vote.value
    #   vote.save
    # end

    render json: @representative_vote.descendants
  end

  def live
    @current_issue = Issue.find(params[:id])
    @current_issue.generate_leaderboard
    @participants = @current_issue.voters.order(id: :asc)
    # number of voters - AR
    # number of yes votes for this issue - AR
    # number of no votes for this issue - AR
    # number of abstains - ruby method
    # number of active votes - ruby method
    # percentage yes - ruby method
    # percentage no - ruby method

  end
end
