namespace :reset_pw do

  desc "reset passwords for all users"
  task reset_passwords: :environment do
    puts 'starting reset_passwords'

    User.all.each do |u|
      random_pw = SecureRandom.hex(8)
      u.password = random_pw
      u.password_confirmation = random_pw
      u.save
    end

    puts 'all passwords reset'

  end

end