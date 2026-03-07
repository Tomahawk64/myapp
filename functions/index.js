const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.promoteUserToPandit = functions.https.onCall(async (data, context) => {
  // Check if the request is made by an admin
  if (context.auth.token.role !== "ADMIN") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can promote users to pandit."
    );
  }

  const userId = data.userId;
  try {
    await admin.firestore().collection("users").doc(userId).update({ role: "PANDIT" });
    return { message: `Successfully promoted user ${userId} to pandit.` };
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message, error);
  }
});

exports.promoteUserToAdmin = functions.https.onCall(async (data, context) => {
  // Check if the request is made by an admin
  if (context.auth.token.role !== "ADMIN") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can promote users to admin."
    );
  }

  const userId = data.userId;
  try {
    await admin.firestore().collection("users").doc(userId).update({ role: "ADMIN" });
    return { message: `Successfully promoted user ${userId} to admin.` };
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message, error);
  }
});
