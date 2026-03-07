
const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.elevateUserToPandit = functions.https.onCall(async (data, context) => {
  // Ensure the user is an admin
  const callerUid = context.auth.uid;
  const callerDoc = await admin.firestore().collection("users").doc(callerUid).get();
  const callerRole = callerDoc.data().role;

  if (callerRole !== "ADMIN") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You must be an admin to perform this action."
    );
  }

  const { userId } = data;

  // Update the user's role to PANDIT
  await admin.firestore().collection("users").doc(userId).update({ role: "PANDIT" });

  // Create a pandit profile document
  await admin.firestore().collection("pandits").doc(userId).set({
    bio: "",
    experienceYears: 0,
    languages: [],
    specialties: [],
    rating: 0,
    ratingCount: 0,
    isAvailable: true,
  });

  console.log(`User ${userId} has been elevated to PANDIT.`);
  return { success: true };
});
