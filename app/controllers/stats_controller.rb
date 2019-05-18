class StatsController < ApplicationController
  before_action :signed_in_user

  def comments
    #TODO need to edit to pull from current rulemaking only
    @total_comments = Comment.count
    @total_commenters = Comment.sum(:num_commenters)

    @comments_manually_entered = Comment.where(manually_entered: true).count
    @comments_imported_from_DAS = @total_comments - @comments_manually_entered

    @comments_by_status_type = CommentStatusType.select('comment_status_types.*, COUNT(comments.id) as num_comments').joins("LEFT JOIN comments ON comment_status_types.id = comments.comment_status_type_id").group('comment_status_types.id').order(:order_in_list)
    @comments_with_no_status_type = Comment.where(comment_status_type_id: nil).count

    @comments_without_suggested_changes = Comment.joins('LEFT JOIN comments_suggested_changes ON comments.id = comments_suggested_changes.comment_id').where('comments_suggested_changes.comment_id IS NULL').count
    @comments_with_suggested_changes = @total_comments - @comments_without_suggested_changes

    @comments_with_multiple_commenters = Comment.where('num_commenters > 1').order(num_commenters: :desc)

  end

  def suggested_changes
    #TODO need to edit to pull from current rulemaking only
    @total_suggested_changes = SuggestedChange.count

    @suggested_changes_by_status_type = SuggestedChangeStatusType.select('suggested_change_status_types.*, COUNT(suggested_changes.id) as num_suggested_changes').joins('LEFT JOIN suggested_changes ON suggested_change_status_types.id = suggested_changes.suggested_change_status_type_id').group('suggested_change_status_types.id').order(:order_in_list)
    @suggested_changes_with_no_status_type = SuggestedChange.where(suggested_change_status_type_id: nil).count

    @suggested_changes_with_no_comments = SuggestedChange.joins('LEFT JOIN comments_suggested_changes ON suggested_changes.id = comments_suggested_changes.suggested_change_id').where('comments_suggested_changes.suggested_change_id IS NULL').order(:suggested_change_name)

    @suggested_changes_by_agency_response = SuggestedChangeResponseType.select('suggested_change_response_types.*, COUNT(suggested_changes.id) as num_suggested_changes').joins('LEFT JOIN suggested_changes ON suggested_change_response_types.id = suggested_changes.suggested_change_response_type_id').group('suggested_change_response_types.id').order(:order_in_list)
    @suggested_changes_with_no_agency_response = SuggestedChange.where(suggested_change_response_type_id: nil).count

    @suggested_changes_by_assigned_to = User.select('users.*, count(suggested_changes.id) as num_suggested_changes').joins("LEFT JOIN suggested_changes ON users.id = suggested_changes.assigned_to_id").group('users.id').order(:name)
    @suggested_changes_not_assigned = SuggestedChange.where(assigned_to_id: nil).count

    #get info for table of suggested_changes with assigned_to and status info
    rows = []
    @suggested_changes_by_assigned_to.each do |user|
      rows.push(get_status_row_this_user(user.id, user.name, user.num_suggested_changes))
    end
    rows.push(get_status_row_this_user(nil, nil, @suggested_changes_not_assigned))
    @suggested_changes_by_assigned_to_and_status = rows
    @suggested_change_status_types = SuggestedChangeStatusType.order(:order_in_list)

  end

  private

  def get_status_row_this_user(user_id, user_name, total_suggested_changes_this_user)
    #TODO need to edit to pull from current rulemaking only
    row = {user_id: user_id, name: user_name, total_suggested_changes: total_suggested_changes_this_user}
    user_id_condition = user_id.nil? ? "suggested_changes.assigned_to_id IS NULL" : "suggested_changes.assigned_to_id = #{user_id}"
    status_types = SuggestedChangeStatusType.select('suggested_change_status_types.*, suggested_changes.assigned_to_id, COUNT(suggested_changes.id) as num_suggested_changes').joins('LEFT JOIN suggested_changes ON suggested_change_status_types.id = suggested_changes.suggested_change_status_type_id').where(user_id_condition).group('suggested_change_status_types.id, assigned_to_id')
    status_types.each do |cst|
      row[cst.id] = cst.num_suggested_changes
    end

    return row
  end

end
