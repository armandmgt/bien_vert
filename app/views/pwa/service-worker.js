// Add a service worker for processing Web Push notifications:

self.addEventListener("install", event => {
  event.waitUntil(self.skipWaiting())
})

self.addEventListener("activate", event => {
  event.waitUntil(self.clients.claim())
})

self.addEventListener("push", event => {
  const { title, options } = event.data.json()
  event.waitUntil(self.registration.showNotification(title, options))
})

self.addEventListener("notificationclick", event => {
  event.notification.close()

  if (!event.notification.data?.path) return

  event.waitUntil(
    self.clients.matchAll({ type: "window" }).then((clientList) => {
      console.log({ clientList })
      for (let i = 0; i < clientList.length; i++) {
        let client = clientList[i]
        let clientPathname = (new URL(client.url)).pathname

        if (clientPathname === event.notification.data.path && "focus" in client) {
          return client.focus()
        }
      }

      if (clientList.length > 0 && "focus" in clientList[0]) {
        console.log(clientList[0])
        return clientList[0].navigate(event.notification.data.path)
          .then(client => client.focus())
      } else if ("openWindow" in self.clients) {
        console.log("openWindow")
        return self.clients.openWindow(event.notification.data.path)
      }
    }),
  )
})
