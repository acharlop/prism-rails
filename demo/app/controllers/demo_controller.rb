class DemoController < ActionController::Base
  layout "application"

  EXAMPLES = [
    {
      title: "Rails Controller",
      language: "ruby",
      code: <<~RUBY
        class ArticlesController < ApplicationController
          def show
            @article = Article.find(params[:id])
            fresh_when @article
          end
        end
      RUBY
    },
    {
      title: "Stimulus Controller",
      language: "javascript",
      code: <<~JS
        export default class extends Controller {
          static targets = ["output"]

          connect() {
            this.outputTarget.textContent = "Prism is loaded"
          }
        }
      JS
    },
    {
      title: "ERB Template",
      language: "erb",
      code: <<~ERB
        <%= tag.article id: dom_id(article) do %>
          <h2><%= article.title %></h2>
          <%= simple_format article.body %>
        <% end %>
      ERB
    }
  ].freeze

  def show
    @examples = EXAMPLES
  end
end
