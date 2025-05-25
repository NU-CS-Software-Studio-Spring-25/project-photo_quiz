import { Application } from "@hotwired/stimulus"
import SearchController from "controllers/search_controller"

const application = Application.start()

application.register("search", SearchController)

application.debug = false
window.Stimulus = application

export { application }
