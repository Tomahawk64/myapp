
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

/**
 * A scheduled Cloud Function that runs every minute to find and expire
 * consultation sessions that have passed their `endTime`.
 */
export const expireConsultationSessions = functions.pubsub
  .schedule("every 1 minutes")
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const query = db
      .collection("consultation_sessions")
      .where("status", "==", "active")
      .where("endTime", "<=", now);

    const snapshot = await query.get();

    if (snapshot.empty) {
      console.log("No expired sessions found.");
      return;
    }

    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      console.log(`Expiring session: ${doc.id}`);
      batch.update(doc.ref, { status: "expired" });
    });

    await batch.commit();
    console.log(`Expired ${snapshot.size} sessions.`);
  });
