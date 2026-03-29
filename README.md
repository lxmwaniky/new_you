# New You - Premium Habit Tracker & AI Coach

![New You Banner](https://via.placeholder.com/1200x400/673AB7/FFFFFF?text=New+You:+Wellness+Tracking+Reimagined)

**New You** is a modern, human-centric wellness application built with Flutter. It moves away from mechanical "button-mashing" habit trackers, favoring passive recognition, premium aesthetics, and intelligent, AI-driven coaching.

## ✨ Features

- **Passive Daily Check-ins:** The app automatically recognizes your presence and logs your daily check-in as soon as you open it.
- **Bento-Style Dashboard:** A visually rich, multi-layered dashboard that displays your current streak, journals, triggers, goals, and community access.
- **NY AI Assistant:** A dedicated, full-screen chat interface powered by Google's **Gemini 2.5 Flash**. The AI acts as a supportive wellness coach and remembers your conversation history.
- **Journaling:** A distraction-free, premium writing environment to reflect on your daily journey.
- **Trigger & Goal Management:** Track obstacles you want to avoid and set long-term goals with visual progress bars.
- **Local Persistence:** All your data (streaks, journals, and chat history) is securely saved locally on your device—no internet required (except for the AI).

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **State Management:** `ChangeNotifier` / `ListenableBuilder` (Built-in)
- **Navigation:** `go_router`
- **Dependency Injection:** `get_it`
- **Persistence:** `shared_preferences`
- **AI Integration:** `google_generative_ai` (Gemini 2.5 Flash)
- **Environment Management:** `flutter_dotenv`

## 🚀 Getting Started

### Prerequisites

1.  **Flutter SDK** installed (version 3.x+).
2.  An Android/iOS emulator or physical device.
3.  A **Gemini API Key** from [Google AI Studio](https://aistudio.google.com/app/apikey).

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/new_you.git
    cd new_you
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Set up your Environment Variables:**
    Create a file named `.env` in the root of the project and add your Gemini API key:
    ```env
    GEMINI_API_KEY=your_api_key_here
    ```
    *(Note: `.env` is included in `.gitignore` to keep your key secure.)*

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 🎨 Design Philosophy

"New You" embraces a **Soft-Minimalist** aesthetic. 
- **Colors:** A soothing palette of Deep Purple, Vibrant Amber, and clean whites/surfaces.
- **Typography:** Modern, heavy weights for headlines to create impact, paired with highly readable body text.
- **Components:** Bento-style grids, multi-layered drop shadows, and subtle glow effects instead of rigid, flat cards.

## 🔒 Privacy & Data

This application prioritizes user privacy. All personal tracking data (journals, triggers, goals, streaks, and chat history) is stored **locally** on the device using `shared_preferences`. Data is only transmitted externally when interacting with the Gemini AI Assistant.

---
*Built with ❤️ for a better you.*
