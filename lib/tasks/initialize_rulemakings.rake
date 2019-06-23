namespace :initialize_rulemakings do

  desc "set up a rulemaking object and link the existing data to it"
  task initialize: :environment do

    if Rulemaking.any?
      puts 'rulemaking objects already exist. No changes made.'
    else
      puts 'adding a rulemaking record for CAO'
      r = Rulemaking.new(rulemaking_name: 'CAO', agency: 'DEQ/OHA')
      r.save

      puts 'connecting existing objects to that record'

      object_groups = [SuggestedChange, SuggestedChangeResponseType, SuggestedChangeStatusType, ChangeLogEntry, Comment, CommentStatusType]

      object_groups.each do |object_type|
        object_type.in_batches.each do |relation|
          relation.update_all(rulemaking_id: r.id)
        end
      end

      'puts adding user permissions for the new rulemaking'
      User.all.each do |u|
        up = UserPermission.new(user: u, rulemaking: r)
        up.admin = u.application_admin
        up.save
      end

      puts 'done initializing rulemakings'
    end
  end
end
