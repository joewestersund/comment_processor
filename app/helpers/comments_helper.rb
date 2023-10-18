module CommentsHelper

  def comments_and_commenters_text(suggested_change)
    comments = suggested_change.num_comments
    commenters = suggested_change.num_commenters

    if commenters > comments
      "#{comments} (#{commenters} commenters)"
    else
      comments
    end
  end

  def import_comments_data(comment_data_source)
    require 'net/http'

    uri = URI(comment_data_source.comment_download_url)
    response = Net::HTTP.get(uri)

    parse_response(comment_data_source,response) #returns the number of comments added to the db

  end

  def parse_response(comment_data_source, response_text)

    comments_added = 0
    response_text.slice! "</entry" #remove the end tags

    entries = response_text.split("<entry>")

    default_comment_status_type = CommentStatusType.order(:order_in_list).first #by default, assign new comments to the first status in the list

    c_max = current_rulemaking.comments.maximum(:order_in_list)
    current_max_order_in_list = c_max.nil? ? 0 : c_max

    entries.each do |entry|
      id = entry.string_between_markers('<d:__id m:type="Edm.Int64">','</d:__id>')

      if id.present? && Comment.find_by(comment_data_source_id: comment_data_source, source_id: id).nil?
        #this comment isn't in the db yet. add it.
        c = Comment.new
        c.comment_data_source = comment_data_source
        c.source_id = id
        c.first_name = entry.string_between_markers('<d:first_name>','</d:first_name>')
        c.last_name = entry.string_between_markers('<d:last_name>','</d:last_name>')
        c.email = entry.string_between_markers('<d:email>','</d:email>')

        rough_organization_name = entry.string_between_markers('<d:organization>','</d:organization>')
        c.organization = clean_text(rough_organization_name) #remove any escape characters

        c.state = entry.string_between_markers('<d:state>','</d:state>')

        rough_comment_text = entry.string_between_markers('<d:comment>','</d:comment>')
        c.comment_text = clean_text(rough_comment_text) #remove any escape characters

        c.manually_entered = false #false because this is imported from DAS
        c.comment_status_type = default_comment_status_type

        c.num_commenters = 1 #default to one

        current_max_order_in_list += 1
        c.order_in_list = current_max_order_in_list

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

  def escape_characters_to_replace
    # first element is the string in comment.comment_text to replace
    # second element is the string to replace it with
    [
        ['&amp;acirc;&amp;euro;&amp;oelig;','"'],
        ['&amp;acirc;&amp;euro;&amp;#65533;','"'],
        ['&amp;acirc;&amp;euro;&amp;trade;',"'"],
        ['&amp;acirc;&amp;euro;&amp;tilde;',"'"],
        ['&amp;acirc;&amp;euro;&amp;cent;','-'],
        ['&amp;acirc;&amp;euro;&amp;rdquo;','-'],
        ['&amp;acirc;&amp;euro;&amp;ldquo;','-'],
        ['&amp;acirc;&amp;euro;&amp;brvbar;',''],
        ['&amp;Acirc;&amp;nbsp;',' '],
        ['&amp;iuml;&amp;fnof;&amp;frac14;','-'],
        ['&amp;Icirc;&amp;frac14;',''],
        ['&amp;Atilde;&amp;iexcl;','a'],
        ['&amp;Atilde;&amp;sup3;','o'],
        ['&amp;Atilde;&amp;ordm;','u'],
        ['&amp;Atilde;&amp;plusmn;',''],
        ['&amp;Atilde;&amp;copy;','e'],
        ['&amp;Atilde;&amp;shy;','i'],
        ['&amp;mdash;','-'],
        ['&amp;rsquo;',"'"],
        ['&amp;bull;','•'],
        ['&amp;quot;','"'],
        ['&amp;amp;','&'],
        ['&amp;','&'],
        ['Ã¢â‚¬â€œ','-'],
        ['Ã¢â‚¬â€','-'],
        ['Ã¢â‚¬â„¢',"'"],
        ['Ã¢â‚¬Å“','"'],
        ['Ã¢â‚¬Â','"'],
        ['&quot;','"'],
        ['â€™',"'"],
        ['â€“','-'],
        ['â€œ','"'],
        ['â€','"']
    ]
  end

  def clean_text(text)
    if text.present?
      escape_characters_to_replace.each do |replace_strings|
        text = text.gsub(replace_strings[0],replace_strings[1])
      end
      #still need to save changes after this method.
      return text
    end
  end

end
