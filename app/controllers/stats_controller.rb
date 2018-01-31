class StatsController < ApplicationController
  before_action :signed_in_user

  def comments
    @total_comments = Comment.count
    @total_commenters = Comment.sum(:num_commenters)

    @comments_manually_entered = Comment.where(manually_entered: true).count
    @comments_imported_from_DAS = @total_comments - @comments_manually_entered

    @comments_by_status_type = CommentStatusType.select('comment_status_types.*, COUNT(comments.id) as num_comments').joins("LEFT JOIN comments ON comment_status_types.id = comments.comment_status_type_id").group('comment_status_types.id').order(:order_in_list)
    @comments_with_no_status_type = Comment.where(comment_status_type_id: nil).count

    @comments_without_categories = Comment.joins('LEFT JOIN categories_comments ON comments.id = categories_comments.comment_id').where('categories_comments.comment_id IS NULL').count
    @comments_with_categories = @total_comments - @comments_without_categories

    @comments_with_multiple_commenters = Comment.where('num_commenters > 1').order(num_commenters: :desc)

  end

  def categories
    @total_categories = Category.count

    @categories_by_status_type = CategoryStatusType.select('category_status_types.*, COUNT(categories.id) as num_categories').joins('LEFT JOIN categories ON category_status_types.id = categories.category_status_type_id').group('category_status_types.id').order(:order_in_list)
    @categories_with_no_status_type = Category.where(category_status_type_id: nil).count

    @categories_with_no_comments = Category.joins('LEFT JOIN categories_comments ON categories.id = categories_comments.category_id').where('categories_comments.category_id IS NULL').order(:category_name)

    @categories_by_agency_response = CategoryResponseType.select('category_response_types.*, COUNT(categories.id) as num_categories').joins('LEFT JOIN categories ON category_response_types.id = categories.category_response_type_id').group('category_response_types.id').order(:order_in_list)
    @categories_with_no_agency_response = Category.where(category_response_type_id: nil).count

    @categories_by_assigned_to = User.select('users.*, count(categories.id) as num_categories').joins("LEFT JOIN categories ON users.id = categories.assigned_to_id").group('users.id').order(:name)
    @categories_not_assigned = Category.where(assigned_to_id: nil).count

    #get info for table of categories with assigned_to and status info
    rows = []
    @categories_by_assigned_to.each do |user|
      rows.push(get_status_row_this_user(user.id, user.name, user.num_categories))
    end
    rows.push(get_status_row_this_user(nil, nil, @categories_not_assigned))
    @categories_by_assigned_to_and_status = rows
    @category_status_types = CategoryStatusType.order(:order_in_list)

  end

  private

  def get_status_row_this_user(user_id, user_name, total_categories_this_user)
    row = {user_id: user_id, name: user_name, total_categories: total_categories_this_user}
    user_id_condition = user_id.nil? ? "categories.assigned_to_id IS NULL" : "categories.assigned_to_id = #{user_id}"
    status_types = CategoryStatusType.select('category_status_types.*, categories.assigned_to_id, COUNT(categories.id) as num_categories').joins('LEFT JOIN categories ON category_status_types.id = categories.category_status_type_id').where(user_id_condition).group('category_status_types.id, assigned_to_id')
    status_types.each do |cst|
      row[cst.id] = cst.num_categories
    end

    return row
  end

end
