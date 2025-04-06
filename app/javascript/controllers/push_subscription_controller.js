import { Controller } from "@hotwired/stimulus"

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}

// This function is needed because Chrome doesn't accept a base64 encoded string
// as value for applicationServerKey in pushManager.subscribe yet
// https://bugs.chromium.org/p/chromium/issues/detail?id=802280
function urlBase64ToUint8Array(base64String) {
  var padding = "=".repeat((4 - base64String.length % 4) % 4)
  var base64 = (base64String + padding)
    .replace(/\-/g, "+")
    .replace(/_/g, "/")

  var rawData = window.atob(base64)
  var outputArray = new Uint8Array(rawData.length)

  for (var i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i)
  }
  return outputArray
}

// Connects to data-controller="push-subscription"
export default class extends Controller {
  static values = { vapidKeyUrl: String, postUrl: String }
  static targets = ["requestToast", "successToast"]

  async connect() {
    const registration = await navigator.serviceWorker.ready

    if ("pushManager" in registration) {
      const subscription = await registration.pushManager.getSubscription()
      if (!subscription) {
        this.requestToastTarget.classList.remove("hidden")
      }
    }
  }

  async subscribe() {
    const registration = await navigator.serviceWorker.ready

    const response = await fetch(this.vapidKeyUrlValue)
    const vapidPublicKey = await response.text()
    const convertedVapidKey = urlBase64ToUint8Array(vapidPublicKey)

    const subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: convertedVapidKey,
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
