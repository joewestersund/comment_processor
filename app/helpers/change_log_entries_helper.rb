module ChangeLogEntriesHelper

  def save_change_log(user,parameters = {})
    cle = ChangeLogEntry.new(user_id: user.id, object_type: parameters[:object_type], action_type: parameters[:action_type], description: parameters[:description])
    if parameters[:comment].present?
      cle.comment_id = parameters[:comment].id
      cle.object_type = 'comment'
      if parameters[:description].blank?
        cle.description = get_comment_change_description(parameters[:comment].previous_changes, parameters[:category_changes])
      end
    elsif parameters[:category].present?
      cle.category_id = parameters[:category].id
      cle.object_type = 'category'
      if parameters[:description].blank?
        cle.description = get_category_change_description(parameters[:category].previous_changes)
      end
    end
    cle.action_type = parameters[:action_type]
    cle.save unless cle.description.blank? #if description blank, no changes were made
  end

  def get_comment_change_description(comment_change_hash, category_change_hash)

    string_array = comment_change_hash.map do |change_item|
      if change_item[0] == 'comment_status_type_id'
        cst = CommentStatusType.find(change_item[1][1]).status_text
        "comment review status changed to '#{cst}'"
      elsif change_item[0] != 'updated_at' #don't want the updated_at timestamp in the description.e
        "#{change_item[0]} changed to '#{change_item[1][1]}'"
      end
    end
    string_array.delete(nil) #don't want skipped items in the description.

    removed = category_change_hash[:removed]
    string_array.push("removed #{'category'.pluralize(removed.count)} #{removed.join(", ")}") if removed.any?
    added = category_change_hash[:added]
    string_array.push("added #{'category'.pluralize(added.count)} #{added.join(", ")}") if added.any?

    return "" if string_array.empty? #no changes
    return string_array.join(', ')
  end

  def get_category_change_description(category_change_hash)

    string_array = category_change_hash.map do |change_item|
      if change_item[0] == 'category_status_type_id'
        cst = CategoryStatusType.find(change_item[1][1]).status_text
        "category review status changed to '#{cst}'"
      elsif change_item[0] == 'category_response_type_id'
        crt = CategoryResponseType.find(change_item[1][1]).response_text
        "category response type changed to '#{crt}'"
      elsif change_item[0] == 'assigned_to_id'
        assigned_to_user = "no one"
        assigned_to_user = User.find(change_item[1][1]).name if change_item[1][1].present?
        "assigned to #{assigned_to_user}"
      elsif change_item[0] != 'updated_at' #don't want the updated_at timestamp in the description.
        "#{change_item[0]} changed to '#{change_item[1][1]}'"
      end
    end
    string_array.delete(nil) #don't want skipped items in the description.

    return "" if string_array.empty? #no changes
    return string_array.join(', ')

  end

end
