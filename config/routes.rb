  # Custom error pages
  %w(404 422 500).each do |code|
    get code, to: "errors#show", code: code
  end