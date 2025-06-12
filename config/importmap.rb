# Pin npm packages by running ./bin/importmap

pin "application"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@popperjs/core", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js", preload: true
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.4.0/dist/js/bootstrap.min.js", preload: true
pin "@rails/ujs", to: "rails-ujs.js"
pin "quiz", to: "quiz.js"
pin "chart.js" # @4.4.9
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
