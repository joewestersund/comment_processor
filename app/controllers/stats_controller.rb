class StatsController < ApplicationController
  before_action :signed_in_user

  def by_status
    @total_comments = Comment.count
    @comments_by_status_type = CommentStatusType.select('comment_status_types.*, COUNT(comments.id) as num_comments').joins("LEFT JOIN comments ON comment_status_types.id = comments.comment_status_type_id").group('comment_status_types.id').order(:order_in_list)

    @total_categories = Category.count
    @categories_by_status_type = CategoryStatusType.select('category_status_types.*, COUNT(categories.id) as num_categories').joins("LEFT JOIN categories ON category_status_types.id = categories.category_status_type_id").group('category_status_types.id').order(:order_in_list)

  end

  def categories
    @categories_by_assigned_to = User.select('users.*, count(categories.id) as num_categories').joins("LEFT JOIN categories ON users.id = categories.assigned_to_id").group('category_status_types.id').order(:order_in_list)
  end

end
