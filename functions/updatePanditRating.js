
const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.updatePanditRating = functions.firestore
  .document("reviews/{reviewId}")
  .onCreate(async (snap, context) => {
    const review = snap.data();
    const panditId = review.panditId;

    // Get the pandit's document
    const panditRef = admin.firestore().collection("pandits").doc(panditId);
    const panditDoc = await panditRef.get();

    if (!panditDoc.exists) {
      console.log(`Pandit with ID ${panditId} does not exist.`);
      return null;
    }

    const panditData = panditDoc.data();

    // Calculate the new average rating
    const newRatingCount = (panditData.ratingCount || 0) + 1;
    const newAverageRating =
      ((panditData.rating || 0) * (newRatingCount - 1) + review.rating) /
      newRatingCount;

    // Update the pandit's profile
    await panditRef.update({
      rating: newAverageRating,
      ratingCount: newRatingCount,
    });

    console.log(`Pandit ${panditId} rating updated to ${newAverageRating}`);
  });
