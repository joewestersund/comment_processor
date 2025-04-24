# from https://makandracards.com/makandra/512456-capybara-okayest-helper-download-inspect-files
module DownloadHelpers

  def download_link(link_or_locator)
    link = link_or_locator.is_a?(String) ? find_link(link_or_locator) : link_or_locator

    result_from_request = page.driver.is_a?(Capybara::Selenium::Driver) ? download_result_via_fetch(link) : download_result_via_rack_test(link)
    expect(result_from_request[:error]).to be_nil, result_from_request[:error]

    # [download] attribute overrides response header
    result_from_attribute = download_result_from_attribute(link)
    result_from_request.merge(result_from_attribute)
  end

  private

  def download_result_via_fetch(link)
    result = link.evaluate_async_script(<<~JS)
      let [done] = arguments
      let url = this.getAttribute('href')

      fetch(url).then(async function(response) {
        if (response.ok) {
          response.text().then(function(text) {
            let contentType = response.headers.get('Content-Type')
            let dispositionHeader = response.headers.get('Content-Disposition')
            let disposition = dispositionHeader?.includes("attachment") ? 'attachment' : 'inline'
            let filenameFromHeader = dispositionHeader?.match?.(/filename="([^"]+)"/)[1]
            let filenameFromURL = new URL(response.url).pathname.split('/').slice(-1)[0]
            let filename = filenameFromHeader || filenameFromURL
            done({ disposition, filename, text, content_type: contentType })
          })
        } else {
          done({ error: `Download failed with status ${response.status}` })
        }
      })
    JS

    result.symbolize_keys
  end

  def download_result_via_rack_test(link)
    old_path = page.current_path
    link.click

    status = page.status_code
    success = status.to_s.starts_with?('2')

    if success
      path = page.current_path
      filename_from_path = path.split('/').last

      result = {
        content_type: page.response_headers['Content-Type'],
        text: page.driver.response.body,
        filename: filename_from_path
      }

      if (disposition_header = page.response_headers['Content-Disposition'])
        disposition_header =~ /(attachment|inline)(?:; filename="([^"]+)")?/

        result[:disposition] = $1
        result[:filename] = $2 if $2
      end
    else
      result = {
        error: "Download failed with status #{status}"
      }
    end

    visit old_path

    result
  end

  def download_result_from_attribute(link)
    # With Selenium link[:download] always return an empty string
    # (instead of nil) when the attribute is missing. This does not happen
    # with any other attribute.
    download_attr = (Capybara.current_driver == :selenium) ? link.evaluate_script('this.getAttribute("download")') : link[:download]

    result = {}

    # If the [download] attribute is set, the browser will download as attachment,
    # even if the attribute value is empty.
    if download_attr
      result = { disposition: 'attachment' }
      if download_attr.present?
        result[:filename] = download_attr
      end
    end

    result
  end

end

