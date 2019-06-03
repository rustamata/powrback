class PagesController < ApplicationController
  def edit
  end

  def update
    update_file_on_github('https://api.github.com/repos/rustamata/rustamata.github.io/contents/index.html',
                          get_doc_with_plugin,
                          "Plugin has been embedded to index.html")
    redirect_to "/pages/edit"
  end

  def rollback
    update_file_on_github('https://api.github.com/repos/rustamata/rustamata.github.io/contents/index.html',
                          get_empty_doc,
                          "index.html has been rolled back to initial state")
    redirect_to "/pages/edit"
  end

  private def update_file_on_github(url, file_content, commit_message)
    if user_has_privilege('repo')
      response = HTTParty.put(url, headers: {"User-Agent": "powerfulOAuth", Authorization: "token #{session[:access_token]}", Accept: "application/json"},
                              body: JSON.generate({message: commit_message, content: Base64.encode64(file_content), sha: get_sha(url)}))
      flash[:notice] = "index.html has been updated"
    else
      raise "No privilege repo available for the user"
    end
  end

  private def get_sha(url)
    if user_has_privilege('repo')
      response = HTTParty.get(url, headers: {"User-Agent": "powerfulOAuth", Authorization: "token #{session[:access_token]}", Accept: "application/json"})
      return response['sha']
    else
      raise "No privilege repo available for the user"
    end
  end

  private def get_empty_doc
    return "<!DOCTYPE html>
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
    return "<!DOCTYPE html>
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