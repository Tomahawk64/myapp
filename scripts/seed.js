/**
 * Firestore Seeding Script
 * ========================
 * Seeds the database with sample data for the Pandit App.
 *
 * Prerequisites:
 *   1. Download your Firebase service account key from:
 *      Firebase Console → Project Settings → Service Accounts → Generate New Private Key
 *   2. Save it as  scripts/serviceAccount.json
 *   3. Run:  cd scripts && npm install && node seed.js
 *
 * What this seeds:
 *   - 3 admin users  (Firebase Auth + users collection)
 *   - 5 pandit users (Firebase Auth + users + pandit_profiles collections)
 *   - 10 pooja packages (pooja_packages collection)
 *   - 10 shop products  (shop_products collection)
 *   - 5 consultation slots (consultation_slots collection)
 *
 * Safe to re-run — existing Auth users are updated, not duplicated.
 */

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccount.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const auth = admin.auth();
const now = admin.firestore.Timestamp.now();

// ─── Helpers ──────────────────────────────────────────────────────────────────

/**
 * Creates (or updates) a Firebase Auth user and writes their record to
 * the `users` Firestore collection.
 */
async function upsertUser({ email, password, displayName, role }) {
  let uid;
  try {
    const existing = await auth.getUserByEmail(email);
    uid = existing.uid;
    await auth.updateUser(uid, { displayName });
    console.log(`  ↺  Updated existing user: ${email} (${uid})`);
  } catch (e) {
    if (e.code === 'auth/user-not-found') {
      const record = await auth.createUser({ email, password, displayName });
      uid = record.uid;
      console.log(`  ✓  Created user: ${email} (${uid})`);
    } else {
      throw e;
    }
  }

  await db.collection('users').doc(uid).set(
    {
      id: uid,
      email,
      displayName,
      role,          // lowercase: 'admin' | 'pandit' | 'user'
      createdAt: now,
      deviceToken: null,
      photoURL: null,
    },
    { merge: true },
  );

  return uid;
}

// ─── Admins ───────────────────────────────────────────────────────────────────

async function seedAdmins() {
  console.log('\n[1/5] Seeding admin users…');
  const admins = [
    { email: 'admin@panditapp.com',       password: 'Admin@1234', displayName: 'App Admin',    role: 'admin' },
    { email: 'admin2@panditapp.com',      password: 'Admin@1234', displayName: 'Ops Admin',     role: 'admin' },
    { email: 'superadmin@panditapp.com',  password: 'Admin@5678', displayName: 'Super Admin',   role: 'admin' },
  ];
  for (const a of admins) await upsertUser(a);
  console.log('  → 3 admin users seeded.');
}

// ─── Pandits ──────────────────────────────────────────────────────────────────

async function seedPandits() {
  console.log('\n[2/5] Seeding pandit users + profiles…');

  const pandits = [
    {
      email: 'pandit.sharma@panditapp.com',
      password: 'Pandit@1234',
      displayName: 'Pt. Rajesh Sharma',
      profile: {
        name: 'Pt. Rajesh Sharma',
        bio: 'Experienced pandit with 20 years in Vedic rituals and astrology. Expert in Griha Pravesh and Vivah ceremonies.',
        specialities: ['Griha Pravesh', 'Vivah Puja', 'Satyanarayan Katha', 'Rudrabhishek'],
        experience: 20,
        languages: ['Hindi', 'Sanskrit', 'English'],
        location: 'Delhi',
        isVerified: true,
        rating: 4.8,
      },
    },
    {
      email: 'pandit.mishra@panditapp.com',
      password: 'Pandit@1234',
      displayName: 'Pt. Vikram Mishra',
      profile: {
        name: 'Pt. Vikram Mishra',
        bio: 'Specializes in Navgraha Puja, Kaal Sarp Dosh Nivaran, and Pitru Dosh Puja with authentic Vedic procedures.',
        specialities: ['Navgraha Puja', 'Kaal Sarp Dosh', 'Pitru Dosh', 'Mangalik Dosh'],
        experience: 15,
        languages: ['Hindi', 'Sanskrit', 'Marathi'],
        location: 'Mumbai',
        isVerified: true,
        rating: 4.6,
      },
    },
    {
      email: 'pandit.tiwari@panditapp.com',
      password: 'Pandit@1234',
      displayName: 'Pt. Suresh Tiwari',
      profile: {
        name: 'Pt. Suresh Tiwari',
        bio: 'Renowned pandit well-versed in Agamic traditions. Expert in temple rituals and astrology consultations.',
        specialities: ['Temple Rituals', 'Astrology', 'Vastu Shastra', 'Mundane Astrology'],
        experience: 18,
        languages: ['Tamil', 'Telugu', 'Sanskrit', 'Hindi'],
        location: 'Chennai',
        isVerified: true,
        rating: 4.9,
      },
    },
    {
      email: 'pandit.pande@panditapp.com',
      password: 'Pandit@1234',
      displayName: 'Pt. Mohan Pande',
      profile: {
        name: 'Pt. Mohan Pande',
        bio: 'Expert in birth chart analysis, kundali matching, and auspicious muhurat selection.',
        specialities: ['Kundali Matching', 'Muhurat', 'Birth Chart', 'Gemology'],
        experience: 12,
        languages: ['Hindi', 'English', 'Gujarati'],
        location: 'Ahmedabad',
        isVerified: false,
        rating: 4.4,
      },
    },
    {
      email: 'pandit.dubey@panditapp.com',
      password: 'Pandit@1234',
      displayName: 'Pt. Anil Dubey',
      profile: {
        name: 'Pt. Anil Dubey',
        bio: 'Priest and spiritual guide with expertise in Vastu correction and energy healing rituals.',
        specialities: ['Vastu Correction', 'Energy Healing', 'Ganga Aarti', 'Shanti Puja'],
        experience: 10,
        languages: ['Hindi', 'Sanskrit', 'Bengali'],
        location: 'Kolkata',
        isVerified: true,
        rating: 4.5,
      },
    },
  ];

  const uids = [];
  for (const p of pandits) {
    const uid = await upsertUser({ email: p.email, password: p.password, displayName: p.displayName, role: 'pandit' });
    uids.push(uid);

    await db.collection('pandit_profiles').doc(uid).set(
      { id: uid, ...p.profile, createdAt: now },
      { merge: true },
    );
  }

  console.log('  → 5 pandits seeded.');
  return uids;
}

// ─── Consultation Slots ───────────────────────────────────────────────────────

async function seedConsultationSlots(panditUids) {
  console.log('\n[3/5] Seeding consultation slots…');

  const panditNames = [
    'Pt. Rajesh Sharma',
    'Pt. Vikram Mishra',
    'Pt. Suresh Tiwari',
    'Pt. Mohan Pande',
    'Pt. Anil Dubey',
  ];

  const prices    = [1500, 1200, 1800, 1000, 1100];
  const durations = [60, 45, 60, 30, 60];
  const hourOffset = [9, 11, 13, 15, 17]; // stagger slots through the day

  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  tomorrow.setHours(0, 0, 0, 0);

  const batch = db.batch();
  panditUids.forEach((uid, i) => {
    const slotStart = new Date(tomorrow);
    slotStart.setHours(hourOffset[i]);

    const slotEnd = new Date(slotStart);
    slotEnd.setMinutes(slotEnd.getMinutes() + durations[i]);

    const ref = db.collection('consultation_slots').doc();
    batch.set(ref, {
      id: ref.id,
      panditId: uid,
      panditName: panditNames[i],
      date: slotStart.toISOString(),
      endDate: slotEnd.toISOString(),
      durationMinutes: durations[i],
      price: prices[i],
      isAvailable: true,
      createdAt: now,
    });
  });

  await batch.commit();
  console.log('  → 5 consultation slots seeded.');
}

// ─── Pooja Packages ───────────────────────────────────────────────────────────

async function seedPoojaPackages() {
  console.log('\n[4/5] Seeding pooja packages…');

  const packages = [
    {
      name: 'Griha Pravesh Puja',
      description: 'Welcome ceremony for a new home with full Vedic rituals, havan, and blessings for prosperity and protection.',
      price: 5100,
      durationInMinutes: 180,
      languages: ['Hindi', 'Sanskrit'],
      imageUrl: 'https://placehold.co/400x300/FF6B35/white?text=Griha+Pravesh',
      isFeatured: true,
    },
    {
      name: 'Satyanarayan Katha',
      description: 'Traditional Satyanarayan puja with complete vrat katha, prasad distribution and Aarti.',
      price: 3100,
      durationInMinutes: 120,
      languages: ['Hindi', 'Sanskrit'],
      imageUrl: 'https://placehold.co/400x300/F7C59F/black?text=Satyanarayan',
      isFeatured: true,
    },
    {
      name: 'Vivah Puja Package',
      description: 'Complete wedding ceremony including sapta padi, mangalsutra dharana, kanyadaan and all rituals.',
      price: 21000,
      durationInMinutes: 300,
      languages: ['Hindi', 'Sanskrit', 'English'],
      imageUrl: 'https://placehold.co/400x300/E84855/white?text=Vivah+Puja',
      isFeatured: true,
    },
    {
      name: 'Rudrabhishek',
      description: 'Powerful Shiva puja with 11 kalash abhishek using milk, honey, curd, ghee and Ganga jal.',
      price: 7500,
      durationInMinutes: 150,
      languages: ['Hindi', 'Sanskrit'],
      imageUrl: 'https://placehold.co/400x300/4059AD/white?text=Rudrabhishek',
      isFeatured: false,
    },
    {
      name: 'Navgraha Shanti',
      description: 'Propitiation of all 9 planets through individual japas and havan to remove malefic effects.',
      price: 11000,
      durationInMinutes: 240,
      languages: ['Hindi', 'Sanskrit', 'Telugu'],
      imageUrl: 'https://placehold.co/400x300/6B4226/white?text=Navgraha',
      isFeatured: false,
    },
    {
      name: 'Kaal Sarp Dosh Puja',
      description: 'Specialized remedial puja to neutralize Kaal Sarp Yoga in the birth chart at auspicious muhurat.',
      price: 9100,
      durationInMinutes: 180,
      languages: ['Hindi', 'Sanskrit'],
      imageUrl: 'https://placehold.co/400x300/2C6E49/white?text=Kaal+Sarp',
      isFeatured: false,
    },
    {
      name: 'Ganesh Puja',
      description: 'Auspicious Ganesh puja to invoke Lord Ganesha for removal of obstacles and success in new ventures.',
      price: 2100,
      durationInMinutes: 60,
      languages: ['Hindi', 'Sanskrit', 'Marathi'],
      imageUrl: 'https://placehold.co/400x300/FF9F1C/black?text=Ganesh+Puja',
      isFeatured: true,
    },
    {
      name: 'Vastu Shanti Puja',
      description: 'Complete Vastu correction ceremony including Vastu purusha puja and directional corrections.',
      price: 8500,
      durationInMinutes: 210,
      languages: ['Hindi', 'Sanskrit', 'Gujarati'],
      imageUrl: 'https://placehold.co/400x300/9B2335/white?text=Vastu+Shanti',
      isFeatured: false,
    },
    {
      name: 'Pitru Dosh Nivaran',
      description: 'Ancestral soul pacification puja with tarpan, pind daan and prayers to release karmic debts.',
      price: 6100,
      durationInMinutes: 150,
      languages: ['Hindi', 'Sanskrit'],
      imageUrl: 'https://placehold.co/400x300/5C4033/white?text=Pitru+Dosh',
      isFeatured: false,
    },
    {
      name: 'Mundan Ceremony',
      description: 'First haircut ceremony (Chooda Karma) for toddlers as per Vedic traditions with havan and blessings.',
      price: 4100,
      durationInMinutes: 90,
      languages: ['Hindi', 'Sanskrit', 'English'],
      imageUrl: 'https://placehold.co/400x300/B5838D/white?text=Mundan',
      isFeatured: false,
    },
  ];

  const batch = db.batch();
  for (const pkg of packages) {
    const ref = db.collection('pooja_packages').doc();
    batch.set(ref, { id: ref.id, ...pkg, createdAt: now });
  }
  await batch.commit();
  console.log('  → 10 pooja packages seeded.');
}

// ─── Shop Products ────────────────────────────────────────────────────────────

async function seedShopProducts() {
  console.log('\n[5/5] Seeding shop products…');

  const products = [
    {
      name: 'Puja Thali Set',
      description: 'Premium brass puja thali with bell, diya, incense holder, and kalash. Perfect for daily worship.',
      price: 850,
      imageUrl: 'https://placehold.co/400x300/B8860B/white?text=Puja+Thali',
      stock: 50,
    },
    {
      name: 'Gomti Chakra (Set of 11)',
      description: 'Natural Gomti Chakra stones from Gomti River. Energized for prosperity, luck, and positive energy.',
      price: 250,
      imageUrl: 'https://placehold.co/400x300/4A90D9/white?text=Gomti+Chakra',
      stock: 100,
    },
    {
      name: 'Pure A2 Ghee (500ml)',
      description: 'A2 cow ghee made from Gir cow milk using traditional bilona method. Essential for havan offerings.',
      price: 650,
      imageUrl: 'https://placehold.co/400x300/FFF3B0/black?text=Pure+Ghee',
      stock: 75,
    },
    {
      name: 'Rudraksha Mala (108 beads)',
      description: 'Authentic 5-mukhi Rudraksha mala hand-knotted with silk thread. Purified with mantras.',
      price: 1200,
      imageUrl: 'https://placehold.co/400x300/8B4513/white?text=Rudraksha',
      stock: 30,
    },
    {
      name: 'Agarbatti Gift Set',
      description: 'Collection of 12 premium incense varieties — Sandalwood, Rose, Jasmine, Mogra — in decorative box.',
      price: 450,
      imageUrl: 'https://placehold.co/400x300/DA70D6/black?text=Agarbatti',
      stock: 120,
    },
    {
      name: 'Camphor Tablets (Pack of 50)',
      description: 'Pure white camphor tablets from natural camphor tree. Ideal for aarti and puja purification.',
      price: 120,
      imageUrl: 'https://placehold.co/400x300/F0F8FF/black?text=Camphor',
      stock: 200,
    },
    {
      name: 'Copper Kalash with Lid',
      description: 'Handcrafted copper kalash (20 cm) with decorative lid. Used in all major puja ceremonies.',
      price: 595,
      imageUrl: 'https://placehold.co/400x300/B87333/white?text=Kalash',
      stock: 40,
    },
    {
      name: 'Sandalwood Paste (50g)',
      description: 'Pure chandan paste for tilak and deity offerings. Cooling, fragrant and ritually pure.',
      price: 180,
      imageUrl: 'https://placehold.co/400x300/DEB887/black?text=Chandan',
      stock: 90,
    },
    {
      name: 'Pancha Dhatu Ganesha Idol',
      description: 'Beautiful Lord Ganesha idol in five-metal alloy — 6 inch, hand-finished. Brings success.',
      price: 2100,
      imageUrl: 'https://placehold.co/400x300/DAA520/black?text=Ganesha',
      stock: 20,
    },
    {
      name: 'Havan Samagri (500g)',
      description: 'Herbal blend with vedic herbs, aromatic roots, and medicinal plants for purifying fire rituals.',
      price: 320,
      imageUrl: 'https://placehold.co/400x300/556B2F/white?text=Havan+Samagri',
      stock: 150,
    },
  ];

  const batch = db.batch();
  for (const product of products) {
    const ref = db.collection('shop_products').doc();
    batch.set(ref, { id: ref.id, ...product, createdAt: now, updatedAt: now });
  }
  await batch.commit();
  console.log('  → 10 shop products seeded.');
}

// ─── Entry Point ──────────────────────────────────────────────────────────────

async function main() {
  console.log('╔══════════════════════════════════════╗');
  console.log('║   Pandit App — Firestore Seed Tool   ║');
  console.log('╚══════════════════════════════════════╝');

  try {
    await seedAdmins();
    const panditUids = await seedPandits();
    await seedConsultationSlots(panditUids);
    await seedPoojaPackages();
    await seedShopProducts();

    console.log('\n╔══════════════════════════════════════╗');
    console.log('║   ✅  Seed completed successfully!   ║');
    console.log('╚══════════════════════════════════════╝\n');

    console.log('Admin credentials:');
    console.log('  admin@panditapp.com        / Admin@1234');
    console.log('  admin2@panditapp.com       / Admin@1234');
    console.log('  superadmin@panditapp.com   / Admin@5678\n');

    console.log('Pandit credentials:');
    console.log('  pandit.sharma@panditapp.com / Pandit@1234');
    console.log('  pandit.mishra@panditapp.com / Pandit@1234');
    console.log('  pandit.tiwari@panditapp.com / Pandit@1234');
    console.log('  pandit.pande@panditapp.com  / Pandit@1234');
    console.log('  pandit.dubey@panditapp.com  / Pandit@1234\n');
  } catch (err) {
    console.error('\n❌  Seed failed:', err);
    process.exit(1);
  }
}

main();
