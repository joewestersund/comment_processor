namespace :initialize_rulemakings do

  desc "set up a rulemaking object and link the existing data to it"
  task initialize: :environment do

    if Rulemaking.any?
      puts 'rulemaking objects already exist. No changes made.'
    else
      puts 'adding a rulemaking record for CAO'
      r = Rulemaking.new(rulemaking_name: 'CAO', agency: 'DEQ/OHA')

      puts 'connecting existing objects to that record'

      object_groups = [Category, CategoryResponseType, CategoryStatusType, ChangeLogEntry, Comment, CommentStatusType]

      object_groups.each do |object_type|
        object_type.each do |object|
          object.rulemaking = r
          object.save
        end
      end

      'puts adding user permissions for the new rulemaking'
      User.each do |u|
        up = UserPermission.new(user: u, rulemaking: r)
        up.admin = u.application_admin
        up.save
      end

      puts 'done initializing rulemakings'
    end
  end
end
