import { installStimulusErrorHandler } from "solid_errors_frontend"
import { Application } from "@hotwired/stimulus"

const application = Application.start()
installStimulusErrorHandler(application)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
