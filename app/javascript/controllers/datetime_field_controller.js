import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  setNow() {
    const now = new Date()
    const formattedDate = now.toISOString().slice(0, 10)
    const formattedTime = now.toTimeString().slice(0, 5)
    this.inputTarget.value = `${formattedDate}T${formattedTime}`
  }
}
