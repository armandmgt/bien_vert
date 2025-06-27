import { Controller } from "@hotwired/stimulus"

export default class FileInputPreview extends Controller {
  static targets = ["input", "previewTemplate", "destination"]

  connect() {
    this.inputTarget.addEventListener("change", (event) => {
      this.destinationTarget.replaceChildren()

      if (this.inputTarget.files && this.inputTarget.files.length > 0) {
        Array.from(this.inputTarget.files).forEach((file) => {
          const reader = new FileReader()
          reader.onload = (e) => {
            const fragment = this.previewTemplateTarget.content.cloneNode(true)
            const img = fragment.querySelector("img")
            if (img && e.target?.result) {
              img.src = e.target.result
            }
            this.destinationTarget.appendChild(fragment)
          }
          reader.readAsDataURL(file)
        })
      }
    })
  }
}
