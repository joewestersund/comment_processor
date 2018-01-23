namespace :initialize_change_log do

  desc "write change_log_entries for existing objects"
  task initialize: :environment do
    puts 'initializing change log entries for existing objects'

    if !ChangeLogEntry.any? #only do this once
      admin_user = User.where(admin: true).first
      CommentStatusType.order(:order_in_list).each {|cst| write_initial_change_log(admin_user, 'comment status type', cst)}
      CategoryStatusType.order(:order_in_list).each {|cst| write_initial_change_log(admin_user, 'category status type', cst)}
      CategoryResponseType.order(:order_in_list).each {|crt| write_initial_change_log(admin_user, 'category response type', crt)}
      Comment.order(:order_in_list).each {|c| write_initial_change_log(admin_user, 'comment', c)}
      Category.order(:category_name).each {|cat| write_initial_change_log(admin_user, 'category', cat)}
      puts "done initializing change log entries for existing objects. Wrote #{ChangeLogEntry.count} records."
    else
      puts 'there are already change log entries in the db.'
    end

  end

  private

    def write_initial_change_log(user, object_type, obj)
      cle = ChangeLogEntry.new(user_id: user.id, object_type: object_type, action_type: 'initialize log', description: obj.as_json)
      if object_type == 'comment'
        cle.comment_id = obj.id
      elsif object_type == 'category'
        cle.category_id = obj.id
      end
      cle.save
    end
end
