namespace :initialize_change_log do

  desc "write change_log_entries for existing objects"
  task initialize: :environment do
    puts 'initializing change log entries for existing objects'

    if ChangeLogEntry.empty? #only do this once
      CommentStatusType.each {|cst| write_initial_change_log('comment status type', cst)}
      CategoryStatusType.each {|cst| write_initial_change_log('category status type', cst)}
      CategoryResponseType.each {|crt| write_initial_change_log('category response type', crt)}
      Comment.each {|c| write_initial_change_log('comment', c)}
      Category.each {|cat| write_initial_change_log('category', cat)}
      puts 'done initializing change log entries for existing objects'
    else
      puts 'there are already change log entries in the db.'
    end

  end

  private

    def write_initial_change_log(object_type,obj)
      cle = ChangeLogEntry.new(object_type: object_type, action_type: 'initialize', description: obj.as_json)
    end
end
