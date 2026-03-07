
# Pandit App Blueprint

## Overview

This document outlines the architecture, features, and design of the Pandit App, a mobile application that connects users with pandits for various religious services.

## Style, Design, and Features

### UI and Design

- **Modern and Intuitive UI**: The app features a clean and modern user interface that is easy to navigate.
- **Dynamic Home Screen**: The home screen includes a personalized greeting, a user profile header with a profile picture, and a search bar for easy access to different categories.
- **Engaging Category Cards**: The category cards on the home screen have a background gradient, a shadow, and a subtle animation to make them more interactive and visually appealing.
- **Consistent Theme**: The app uses a consistent color scheme, typography, and component styles throughout the application, with support for both light and dark modes.

### Navigation

- **Imperative Navigation**: The app uses `Navigator.push` for simple, imperative navigation between screens.

### Features

- **User Authentication**: Users can create an account and log in to the app.
- **Pandit Listings**: Users can browse a list of available pandits, view their profiles, and see their specializations and reviews.
- **Pooja Booking**: Users can book a pooja with a specific pandit by selecting a pooja, date, and time.
- **Online Consultation**: Users can book an online consultation with a pandit by selecting a date and time.
- **Search Functionality**: Users can search for pandits and categories on the home screen and the pandit list screen.
- **Role-based access control**: The app displays different categories and features based on the user's role (USER, PANDIT, or ADMIN).

### Data Model Refactoring and Fixes

- **Standardized Data Models**: All data models in `lib/models` have been refactored to use the `freezed` package for immutable data classes and `json_serializable` for robust JSON conversion.
- **`freezed` package update fix**: All freezed models have been updated with the `abstract` keyword to comply with the latest version of the `freezed` package, resolving build-time errors.
- **New `UserProfile` Model**: A new `UserProfile` model (`lib/models/user_profile.dart`) was created to represent user profile data from Firestore.
- **Consistent Factory Constructors**: Each model now includes consistent factory constructors:
    - `fromJson(Map<String, dynamic> json)` for creating instances from JSON.
    - `fromFirestore(DocumentSnapshot doc)` for creating instances directly from Firestore documents, which improves data consistency and reduces boilerplate code.
- **Generated Files**: All `*.freezed.dart` and `*.g.dart` files have been regenerated to reflect the updated model definitions, ensuring type safety and correct serialization/deserialization.

## Current Plan

The data models have been successfully refactored and fixed. The next step is to address any remaining errors in the codebase that may have arisen from these changes and then continue with feature development. The application is now in a stable state regarding its data layer. I will now check the rest of the app for any compilation errors.
