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
  if (!event.notification.data?.path) return

  event.waitUntil(
    self.clients.matchAll({ type: "window" }).then((clientList) => {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i]
        const clientPathname = (new URL(client.url)).pathname

        if (clientPathname === event.notification.data.path && "focus" in client) {
          return client.focus()
        }
      }

      if ("openWindow" in self.clients) {
        return self.clients.openWindow(event.notification.data.path)
      }
    }),
  )
})
