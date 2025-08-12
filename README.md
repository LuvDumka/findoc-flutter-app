# Findoc App

This is my Flutter app for the Findoc assignment. It has two main screens - a login page and a home page that shows photos from an API.

## What it does

The app starts with a login screen where you need to enter your email and password. After logging in successfully, you get taken to the home screen which displays photos fetched from the internet.

### Login Screen
- You have to enter a valid email address
- Password needs to be at least 8 characters with uppercase, lowercase, numbers and special characters
- Shows error messages if you enter wrong format
- Has a loading spinner when you tap login

### Home Screen  
- Shows a gallery of photos from Picsum API
- Each photo has the author name below it
- If something goes wrong loading photos, it shows an error message

## Technical stuff

I used BLoC for state management as required in the assignment. The app structure is:

```
lib/
├── blocs/           # State management files
├── models/          # Data classes
├── screens/         # Login and Home screens
├── services/        # API calling logic
├── utils/           # Validation functions
├── widgets/         # Custom widgets
└── main.dart        # Main app file
```

The main packages I used:
- flutter_bloc - for managing app state
- http - to call the photos API
- google_fonts - for Montserrat font
- formz - for form validation

## API Details

I'm using Picsum Photos API to get random images:
- URL: https://picsum.photos/v2/list?limit=10
- Returns JSON with photo data including author names and image URLs

## Login info

You can use any email that looks valid (like test@gmail.com) and any password that meets the requirements (like Password123!).

---
