# 🕹️ Athif OS: The Gamified Portfolio
> **"Why build a website when you can build an experience?"**

**Athif OS** is a Flutter-based "Interactive Desktop" that blurs the line between a professional portfolio and a retro video game. It’s built for the curious—those willing to "unlock" the system and explore a digital world.

**🌐 Explorer Portal:** [athif-os.vercel.app](https://athif-os.vercel.app)  
**📡 Command Center:** [portfolio-backend-bnhn.onrender.com](https://portfolio-backend-bnhn.onrender.com)

---

## 📺 The Experience

* **🔐 The Gatekeeper (Lock Screen):** A two-stage biometric-style onboarding. Choose your callsign, drop an optional link, and step inside.
* **🖥️ The Desktop (Home):** Features dynamic parallax hills, floating clouds, and a retro-clock widget. Use the slide-to-unlock interaction to access the core data.
* **📱 Physics Playground (Mobile):** Detected a small screen? The OS automatically switches to "Bouncing DVD" mode—a physics-based simulation with Mario-inspired sound effects to keep you entertained.
* **🏦 The Vault (Admin Panel):** A high-security bridge using JWT Fragment Handoff. I track "digital footprints" through a real-time analytics dashboard with traffic trend charts.

---

## 🛠️ The Tech Stack

| Component | Technology | Role |
| :--- | :--- | :--- |
| **🎮 Engine** | **Flutter Web** | Powering the 60 FPS UI, custom shaders, and animations. |
| **🧠 Brain** | **FastAPI (Python)** | High-performance backend logic & JWT authentication. |
| **💾 Memory** | **PostgreSQL (Neon)** | Serverless database storing visitor callsigns & traffic logs. |
| **🔐 Identity** | **JWT + Cookies** | A secure two-stage handshake for session persistence. |

---

## 🔒 Security: The "Fragment" Handshake

I implemented a privacy-focused authentication flow to prevent sensitive data from ever touching server logs:

1.  **Admin Login:** Admin authenticates via the Flutter frontend.
2.  **The Transport:** The JWT token is passed via **URL Fragment (`#`)**.
    * *Why?* Fragments are client-side only. They are **never** sent to the server in HTTP requests.
3.  **The Bridge:** A bootstrap page reads the `#fragment`, calls a local `/set-session` endpoint, and converts the token into a **First-Party Cookie**.
4.  **The Result:** The URL is cleaned instantly. No sensitive tokens are left in history or server logs.

---

## 🚀 Deployment Command Log

In this architecture, the browser sees compiled JavaScript, not Dart. To ensure the latest logic is live, I follow this sequence:

```bash
# 1. Purge old artifacts
flutter clean

# 2. Recompile the JS Engine
flutter build web --release

# 3. Ship to Cloud (Force clear Vercel cache)
vercel --prod --force
```

## 🎮 Fun Facts

- 🎵 Sound effects inspired by **Mario**
- 🪙 Coin → Navigation
- 🍄 1-Up → Successful login
- 🕴️ Jump/Woah → UI interactions

---

## 📬 Let's Connect

If you:

- Found a bug 🐞
- Have ideas 💡
- Want to collaborate 🤝

Feel free to reach out:

- LinkedIn: Mohamed Athif N
- GitHub: A-THIF
---

> *Built with creativity, curiosity, and a bit of nostalgia.*
