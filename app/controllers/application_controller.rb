  # Custom error handling
  def render_error(status)
    render template: "errors/#{status}", status: status, layout: "application"
  end