# 🌿 BienVert

**BienVert** is an open-source plant care reminder app that helps you take better care of your plants by notifying you when it’s time to water them. Built with Ruby on Rails, it’s easy to deploy, extend, and make your own — perfect for plant lovers and devs alike!

## ✨ Features

- 🪴 Add and manage your plants
- 🤖 Plant recognition using AI (currently using OpenAI GPT-4o)
- 🔔 Smart reminders based on the recommended watering frequency
- 💚 Clean and simple UI
- 🚀 Easy deployment with [Kamal](https://kamal-deploy.org)

---

## 🆓 Free hosted version

You can use this application for free at https://bien-vert.armandmgt.fr. But since it is using my personal OpenAI API credits I put in place an approval system to avoid misuse. You can register and I will periodically check pending registrations, once approved you will be able to connect to the app !

---

## 🛠️ Tech Stack

- **Backend**: Ruby on Rails
- **Frontend**: Hotwire + Flowbite
- **Database**: SQLite (for easy deployment)
- **Deployment**: Kamal
- **Notifications**: WebPush notification (via Rpush gem)

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/armandmgt/bien_vert.git
cd bien_vert
```

### 2. Set up the project

Make sure you have the correct Ruby version (found in .ruby-version) then:

```bash
./bin/setup
```

Open your browser at `http://localhost:3000`.

---

## ☁️ Deployment with Kamal

### 1. Configure Kamal

Kamal is currently configured to deploy to the hosted version at https://bien-vert.armandmgt.fr. But you can of course configure it to deploy your own self-hosted version 🚀

Edit `config/deploy.yml` and change the following settings:

```yaml
image: your-docker-registry/bien_vert
servers:
  web: [ ip.of.your.server ] # or domain name
  job:
    hosts: [ ip.of.your.server ]
    cmd: bin/jobs
  rpush:
    hosts: [ ip.of.your.server ]
    cmd: bin/rpush start -f

proxy:
  ssl: true
  host: your-domain.com # domain at which the app will be accessible

registry:
  server: ghcr.io    # can be any docker registry
  username: username # your registry username
  password:
    - KAMAL_REGISTRY_PASSWORD # if you are not using GitHub container registry, go to .kamal/secrets to fetch the password from some secure place
```

Also remove `config/credentials.yml.enc` and create new credentials using `rails credentials:edit`. The application requires the following credentials:

```yaml
secret_key_base: xxxxxx

openai:
  api_key: xxxxxx
```

### 3. Deploy

```bash
kamal setup
kamal deploy
```

Check [kamal-deploy.org](https://kamal-deploy.org/docs) for more details.

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.

### To contribute:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a pull request

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🌱 Credits

Logo generated with AI and edited manually.

Application UI is built using [Flowbite](https://flowbite.com)

---

## 📬 Contact

Have suggestions or feedback? Open an issue or reach out!
