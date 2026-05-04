# ✈️ PersonaPath

**PersonaPath** is a state-of-the-art Flutter application that craft personalized travel itineraries using Artificial Intelligence. By understanding your unique travel "persona" through an interactive quiz, the app generates tailor-made journeys that match your vibe, pace, and preferences.

---

## 🌟 Key Features

- **🧠 AI-Driven Quiz**: A beautiful, 6-step interactive quiz to capture your travel style (Scenery, Pace, Nightlife, Driving, etc.).
- **⚡ Real-time Itinerary Generation**: Uses Google Gemini AI to build detailed 5-day plans with specific activities, timings, and notes.
- **🔐 Secure Authentication**: Integrated with Firebase Auth (Email/Password & Google Sign-In).
- **📂 Personal Itinerary History**: Save and revisit all your generated journeys.
- **🌓 Modern UI/UX**: Sleek design featuring smooth transitions, progress tracking, and responsive layouts.
- **☁️ Cloud Sync**: Real-time data persistence using Cloud Firestore.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (latest stable)
- **State Management**: [BLoC / Cubit](https://pub.dev/packages/flutter_bloc)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore)
- **AI Engine**: [Google Gemini API](https://ai.google.dev/)
- **API Handling**: `http` with JSON serialization

---

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK (`^3.10.8`)
- Dart SDK (`^3.0.0`)
- A Firebase Project
- A Gemini API Key from [Google AI Studio](https://aistudio.google.com/)

### 2. Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/persona_path.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Environment Variables:
   Create a `.env` file in the root directory:
   ```env
   AI_API_KEY=your_gemini_api_key_here
   AI_ENDPOINT=https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent
   ```
4. Setup Firebase:
   - Run `flutterfire configure` to link your project.
   - Enable Email/Password and Google Sign-In in Firebase Console.
   - Enable Firestore Database.

### 3. Run the App
```bash
flutter run
```

---

## 📂 Project Structure

```text
lib/
├── core/              # Constants, Theme, Routing, Config
├── data/
│   ├── models/        # Data entities (Itinerary, User, Quiz)
│   ├── services/      # AI & Firestore implementation
├── presentation/
│   ├── cubit/         # State management logic
│   ├── screens/       # Full pages (Home, Quiz, Result, etc.)
│   ├── sections/      # Reusable UI sections (Quiz steps)
│   └── widgets/       # Shared UI components (Buttons, Inputs)
└── main.dart          # Entry point
```

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

Developed with ❤️ by [Ahmed Hassaan](https://github.com/AhmedHassaan-7OS)
