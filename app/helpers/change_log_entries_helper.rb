module ChangeLogEntriesHelper

  def save_change_log(user,comment,category,description,category_change_hash)
    cle = ChangeLogEntry.new(user_id: user.id, description: description)
    if comment.present?
      cle.comment_id = comment.id
      if description.blank?
        cle.description = get_comment_change_description(comment.previous_changes, category_change_hash)
      end
    elsif category.present?
      cle.category_id = category.id
      if description.empty?
        cle.description =get_category_change_description(category.previous_changes)
      end
    end
    byebug
    cle.save
  end

  def get_comment_change_description(comment_change_hash, category_change_hash)
    string_array = comment_change_hash.map do |change_item|
      if change_item[0] == 'comment_status_type_id'
        crt = CommentStatusType.find(change_item[1][0]).status_text
        "comment review status (changed to '#{crt}')"
      elsif change_item[0] == 'num_commenters'
        "num_commenters (changed to #{change_item[1][1]})"
      else
        change_item[0]
      end
    end
    string_array.delete('updated_at') #don't want the updated_at timestamp in the description.

    removed = category_change_hash[:removed]
    string_array.push("removed #{'category'.pluralize(removed.count)} #{removed.join(", ")}") if removed.any?
    added = category_change_hash[:added]
    string_array.push("added #{'category'.pluralize(added.count)} #{added.join(", ")}") if added.any?

    return "made changes to #{string_array.join(', ')}"
  end

  def get_category_change_description(category_change_hash)
    byebug
  end

end
