
const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.sendNotification = functions.https.onCall(async (data, context) => {

  const { userId, message } = data;

  // Create a new notification document
  await admin.firestore().collection("notifications").add({
    userId,
    message,
    isRead: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`Notification sent to user ${userId}`);
  return { success: true };
});
