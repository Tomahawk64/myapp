// Firebase Messaging Service Worker
// Required for Firebase Cloud Messaging on web

importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyB75pQrspkvXHqgbOpQ6Ba0C2RQZpGL7SU",
  authDomain: "fir-pooja-61114.firebaseapp.com",
  projectId: "fir-pooja-61114",
  storageBucket: "fir-pooja-61114.firebasestorage.app",
  messagingSenderId: "1010420338510",
  appId: "1:1010420338510:web:301e008979ef152787181f",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification?.title ?? 'New Notification';
  const notificationOptions = {
    body: payload.notification?.body ?? '',
    icon: '/icons/Icon-192.png',
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
