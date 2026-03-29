# PersonaPath Constitution
## Core Principles
### I. Flutter-First & Student-Friendly Code
Every feature and screen must be written in clean, simple Flutter code that a university student can understand.  
- Every screen is divided into clear Sections + reusable Custom Widgets.  
- No complex code in one file.  
- Comments in Arabic + English where needed.  
- Maximum use of const, final, and named constructors.

### II. Constants-First (NON-NEGOTIABLE)
All colors, text styles, paddings, API keys, and spacing live in one file: `lib/core/constants.dart`  
- Never hard-code colors, sizes, or strings anywhere else.  
- Theme must be: White background (#FFFFFF), Orange primary (#FF9800 for buttons & outlines), Blue accent (#2196F3).  
- All paddings, border radius, and animations defined as const values.

### III. Minimum 12 Screens + Custom Widgets
The app must have at least 12 screens (use named routes).  
Every screen = Sections of reusable Custom Widgets (QuizOptionCard, OrangeButton, ItineraryCard, BackgroundContainer, etc.).  
Animations required: Fade, Scale, Hero on images, AnimatedOpacity on loading.

### IV. Bloc/Cubit + Firebase Only
- State management: flutter_bloc (Cubit only – no Provider or Riverpod).  
- Firebase: Auth (Email/Password + Google Sign-In only) + Firestore (no Storage).  
- Collections: users + itineraries.  
- All data saved in Firestore.

### V. AI Integration at the End
After the 5-question quiz, send answers + fixed prompt to AI (OpenAI/Grok).  
AI returns JSON (title, description, days, activities, imageUrls).  
Display text + NetworkImage instantly and save everything in Firestore.

## Additional Constraints
- Architecture: Clean (lib/core, lib/data, lib/presentation).  
- Assets: Use assets/icons/personapathicon.png and assets/images/background.png.  
- Login: Only Email/Password + Google (no Apple or Facebook).  
- Design: Modern clean UI, lots of white space, orange outlines, big buttons.  
- No external packages except the ones we added (firebase_*, flutter_bloc, http, google_sign_in).  
- All API keys and secrets in constants.dart only.

## Development Workflow
1. Read spec/personapath.md first.  
2. Implement one screen or feature at a time.  
3. Use Custom Widgets + constants.dart everywhere.  
4. Add simple animations where user interacts.  
5. After quiz → call AI → show result → save to Firestore.

## Governance
This Constitution is the highest authority.  
Any generated code must follow all principles above.  
Amendments only by editing this file and re-implementing.

**Version**: 1.0 | **Ratified**: March 2026 | **Last Amended**: March 2026