module ChangeLogEntriesHelper

  def save_change_log(user,obj,description=nil,category_change_hash=nil)
    cle = ChangeLogEntry.new(user_id: user.id, description: description)
    if obj.is_a?(Comment)
      cle.comment_id = obj.id
      if description.blank?
        cle.description = get_comment_change_description(obj.previous_changes, category_change_hash)
      end
    elsif obj.is_a?(Category)
      cle.category_id = obj.id
      if description.blank?
        cle.description = get_category_change_description(obj.previous_changes)
      end
    else
      raise "error: unknown object passed to ChangeLogEntriesHelper.save_change_log()"
    end
    cle.save unless cle.description.blank?
  end

  def get_comment_change_description(comment_change_hash, category_change_hash)
    string_array = comment_change_hash.map do |change_item|
      if change_item[0] == 'comment_status_type_id'
        cst = CommentStatusType.find(change_item[1][1]).status_text
        "comment review status (changed to '#{cst}')"
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

    return "" if string_array.empty? #no changes
    return "made changes to #{string_array.join(', ')}"
  end

  def get_category_change_description(category_change_hash)
    string_array = category_change_hash.map do |change_item|
      if change_item[0] == 'category_status_type_id'
        cst = CategoryStatusType.find(change_item[1][1]).status_text
        "category review status (changed to '#{cst}')"
      elsif change_item[0] == 'category_response_type_id'
        crt = CategoryResponseType.find(change_item[1][1]).response_text
        "category review status (changed to '#{crt}')"
      elsif change_item[0] == 'assigned_to_id'
        assigned_to_user = "no one"
        assigned_to_user = User.find(change_item[1][1]).name if change_item[1][1].present?
        "assigned to #{assigned_to_user}"
      elsif change_item[0] == 'rule_change_made'
        "rule_change_made set to #{change_item[1][1]})"
      else
        change_item[0]
      end
    end
    string_array.delete('updated_at') #don't want the updated_at timestamp in the description.
    return "" if string_array.empty? #no changes
    return "made changes to #{string_array.join(', ')}"
  end

end
