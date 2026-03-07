
const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.onUserCreate = functions.auth.user().onCreate(async (user) => {
  const { uid, email, displayName, photoURL } = user;

  // Create a new user document in Firestore
  await admin.firestore().collection("users").doc(uid).set({
    displayName,
    photoURL,
    email,
    role: "USER", // Default role
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`User document created for ${uid}`);
});
