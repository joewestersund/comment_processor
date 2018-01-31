namespace :initialize_text_from_comments do

  desc "move category.description to category.text_from_comments"
  task initialize: :environment do
    puts 'moving description to text_from_comments for existing categories'

    if !Category.where("text_from_comments IS NOT NULL and text_from_comments <> ''" ).any? #only do this once
      Category.all.each do |cat|
        cat.text_from_comments = cat.description
        cat.description = nil
        cat.save
      end
      puts "done moving category descriptions to text_from_comments field. Updated #{Category.count} records."
    else
      puts 'there are already text_from_comments for some categories in the db.'
    end

  end
end
