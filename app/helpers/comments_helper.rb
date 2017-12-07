module CommentsHelper

  def rulemaking_data_source
    'https://data.oregon.gov/OData.svc/gvv7-qhw2'  #OData v2
  end

  def import_comments_data_odata(comment_data_url)
    #note, this doesn't work. Gives 400 bad request error.
    require 'ruby_odata'

    svc = OData::Service.new(comment_data_url)
    svc.Entries
    entries = svc.execute
  end

  def import_comments_data(comment_data_url)
    require 'net/http'

    uri = URI(comment_data_url)
    response = Net::HTTP.get(uri)

    parse_response(response) #returns the number of comments added to the db

  end

  def parse_response(response_text)

    comments_added = 0
    response_text.slice! "</entry" #remove the end tags

    entries = response_text.split("<entry>")

    default_comment_status_type = CommentStatusType.order(:order_in_list).first #by default, assign new comments to the first status in the list

    entries.each do |entry|
      id = entry.string_between_markers('<d:__id m:type="Edm.Int64">','</d:__id>')

      if id.present? && Comment.find_by(source_id: id).nil?
        #this comment isn't in the db yet. add it.
        c = Comment.new
        c.source_id = id
        c.first_name = entry.string_between_markers('<d:first_name>','</d:first_name>')
        c.last_name = entry.string_between_markers('<d:last_name>','</d:last_name>')
        c.email = entry.string_between_markers('<d:email>','</d:email>')
        c.organization = entry.string_between_markers('<d:organization>','</d:organization>')
        c.state = entry.string_between_markers('<d:state>','</d:state>')
        c.comment_text = entry.string_between_markers('<d:comment>','</d:comment>')
        c.manually_entered = false #false because this is imported from DAS
        c.comment_status_type = default_comment_status_type

        attached_document_info = entry.string_between_markers('<d:additional_document m:type="data.oregon.gov.document">','</d:additional_document>')
        unless attached_document_info.to_s.strip.empty?
          c.attachment_name = attached_document_info.string_between_markers('<d:name>','</d:name>')
          c.attachment_url = attached_document_info.string_between_markers('<d:url>','</d:url>')
        end

        if c.save
          comments_added += 1
        end
      end
    end

    comments_added

  end


end
