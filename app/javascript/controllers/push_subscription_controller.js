import { BridgeComponent, BridgeElement } from "@hotwired/hotwire-native-bridge"

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}

// Connects to data-controller="push-subscription"
export default class extends BridgeComponent {
  static values = { vapidKeyUrl: String, postUrl: String, needsNewToken: Boolean }
  static targets = ["requestToast", "successToast"]
  static component = "push-subscription"

  async connect() {
    if (Object.hasOwn(document.body.dataset, "hotwireNative")) {
      this.subscribeNative()
    } else {
      const registration = await navigator.serviceWorker.ready

      if ("pushManager" in registration) {
        const subscription = await registration.pushManager.getSubscription()
        if (!subscription) {
          this.requestToastTarget.classList.remove("hidden")
        }
      }
    }
  }

  subscribeNative() {
    this.send("connect", { needsNewToken: this.needsNewTokenValue }, message => {
      if (message.data.deviceToken) {
        const deviceToken = message.data.deviceToken
        fetch(this.postUrlValue, {
          method: "post",
          headers: {
            "Content-type": "application/json",
            "X-CSRF-Token": getMetaValue("csrf-token"),
          },
          body: JSON.stringify({
            device_token: deviceToken,
          }),
        })

        this.successToastTarget.classList.remove("hidden")
        setTimeout(() => this.successToastTarget.classList.add("hidden"), 5000)
      }
    })
  }

  async subscribeBrowser() {
    const registration = await navigator.serviceWorker.ready

    const response = await fetch(this.vapidKeyUrlValue)
    const vapidPublicKey = await response.text()
    const subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: vapidPublicKey,
    })

    await fetch(this.postUrlValue, {
      method: "post",
      headers: {
        "Content-type": "application/json",
        "X-CSRF-Token": getMetaValue("csrf-token"),
      },
      body: JSON.stringify({
        push_subscription: subscription,
      }),
    })

    this.requestToastTarget.classList.add("hidden")
    this.successToastTarget.classList.remove("hidden")
    setTimeout(() => this.successToastTarget.classList.add("hidden"), 5000)
  }
}
