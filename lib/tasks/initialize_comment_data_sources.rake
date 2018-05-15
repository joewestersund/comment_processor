namespace :initialize_comment_data_sources do

  desc "set up a comment data source, and link each existing comment to it"
  task initialize: :environment do
    puts 'starting code to set up a comment data source'

    if !CommentDataSource.any? #only do this once
      puts 'adding a comment data source'
      cds = CommentDataSource.new(data_source_name: "CAO Comment Period 1",
                                  description: "10/20/2017 to 1/22/2018",
                                  comment_download_url: 'https://data.oregon.gov/OData.svc/gvv7-qhw2',
                                  active: true)
      cds.save
      puts 'linking each comment to the new comment data source that was created'
      Comment.all.each do |c|
        c.comment_data_source = cds
        c.save
      end
      puts "done updating comment data source for existing comment records. Updated #{Comment.count} records."
    else
      puts 'comment data sources are already set up in the database.'
    end

  end
end
