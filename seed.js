const admin = require("firebase-admin");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedDatabase() {

  // USERS
  await db.collection("users").doc("demo_user").set({
    name: "Demo User",
    email: "demo@mail.com",
    personalityType: "",
    photoUrl: ""
  });

  // QUIZ QUESTIONS
  await db.collection("quiz_questions").doc("q1").set({
    question: "What's your ideal morning?",
    options: [
      "Quiet Sunrise Hike",
      "Bustling Local Market",
      "Relaxed Beach Walk"
    ],
    order: 1
  });

  await db.collection("quiz_questions").doc("q2").set({
    question: "City or Nature?",
    options: [
      "Big City",
      "Nature",
      "Mountains"
    ],
    order: 2
  });

  // QUIZ RESPONSES
  await db.collection("quiz_responses").doc("demo_response").set({
    userId: "demo_user",
    answers: []
  });

  // AI RESULTS
  await db.collection("ai_results").doc("demo_ai").set({
    userId: "demo_user",
    resultText: "Explorer traveler",
    images: []
  });

  // ITINERARIES
  await db.collection("itineraries").doc("demo_trip").set({
    userId: "demo_user",
    title: "Adventure in the Alps",
    places: ["Zurich", "Interlaken", "Zermatt"]
  });

  console.log("Database seeded successfully!");
}

seedDatabase();