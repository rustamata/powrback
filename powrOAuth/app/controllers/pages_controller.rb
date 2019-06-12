class PagesController < ApplicationController
  def edit #show edit form
  end

  def update #add plugin
    update_file_on_github('https://api.github.com/repos/rustamata/rustamata.github.io/contents/index.html',
                          get_doc_with_plugin,
                          "Plugin has been embedded to index.html")
  end

  def rollback #remove plugin
    update_file_on_github('https://api.github.com/repos/rustamata/rustamata.github.io/contents/index.html',
                          get_empty_doc,
                          "index.html has been rolled back to initial state")
  end


  private def update_file_on_github(url, file_content, commit_message)
    begin
      response = HTTParty.put(url, headers: {"User-Agent": get_app_name, Authorization: "token #{get_session_token}", Accept: "application/json"},
                              body: JSON.generate({message: commit_message, content: Base64.encode64(file_content), sha: get_sha(url)}))
      if response.headers["status"] == "200 OK"
        flash[:notice] = "index.html has been updated"
      else
        flash[:error] = "Unable to update index.html, status= #{response.headers["status"]}"
      end
    rescue
      flash[:error] = "Unable to update index.html: #{$!}"
    end
    redirect_to pages_edit_path
  end

  private def get_sha(url)
    begin
      response = HTTParty.get(url, headers: {"User-Agent": get_app_name, Authorization: "token #{get_session_token}", Accept: "application/json"})
      return response['sha']
    rescue
      raise "Unable to get SHA from GitHub, #{$!}"
    end
  end

  private def get_session_token #get GitHub token from session
    session[:access_token]
  end

  private def get_app_name #get application's name from environment variable
    ENV['GH_BASIC_APP_NAME']
  end

  private def get_empty_doc
    "<!DOCTYPE html>
        <html>
        <head>
        <title>rustamata.github.io</title>
        </head>
        <body>
        <h1>Hello World</h1>
        <p>I'm hosted with GitHub Pages.</p>
        </body>
        </html>"
  end

  private def get_doc_with_plugin
    "<!DOCTYPE html>
        <html>
        <head>
        <title>rustamata.github.io</title>
        <script src=\"https://www.powr.io/powr.js\"></script>
        </head>
        <body>
        <h1>Hello World</h1>
        <p>I\'m hosted with GitHub Pages.</p>
        <div class=\"powr-form-builder\" id=\"unique-uuid\"></div>
        </body>
        </html>"
  end

end