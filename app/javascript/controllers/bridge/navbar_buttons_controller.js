import { BridgeComponent, BridgeElement } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "navbar-buttons"
  static targets = ["item"]

  connect() {
    super.connect()

    const items = this.itemTargets.map(target => {
      const element = new BridgeElement(target)
      return {
        title: element.title,
        iosImage: element.bridgeAttribute("ios-image"),
        androidImage: element.bridgeAttribute("android-image"),
      }
    })
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

    this.send("connect", { items, csrfToken }, message => {
      const item = this.itemTargets[message.data.index]
      new BridgeElement(item).click()
    })
  }

  disconnect() {
    super.disconnect()
    this.send("disconnect")
  }
}