# DriveNote

DriveNote is a Flutter application that allows users to create, view, edit, and store plain text notes directly in their Google Drive. It utilizes Google OAuth 2.0 for authentication and securely uploads notes to a dedicated folder in the user's Drive. 

## Features

•  Google Sign-In using OAuth 2.0

• Sync notes to a private folder in Google Drive

• Create, Read, update, and Delete text notes

• Light/Dark theme

• Persistent user session and silent sign-in

• Secure token storage 

• Clean and responsive UI

## Packages Used
 •  flutter_riverpod: ^2.0.0

 •  go_router: ^6.0.0

 •  dio: ^5.0.0

 •  google_sign_in: ^6.0.0

 •  flutter_secure_storage: ^9.0.0

 •  http_parser: ^4.0.0

 •  flex_color_scheme: ^8.2.0

 •  google_fonts: ^6.2.1

## SetUp Instructions



1.Clone the repo
  ```bash
  git clone https://github.com/Dheeraj-Chintala/Android-Apps.git
  cd drivenotes


_flutter pub get_



### Set up Google OAuth

_Go to Google Cloud Console_

_Create a new project_

_Enable Google Drive API_

_Create an OAuth 2.0 Client ID_

_Add your client ID to the app’s GoogleSignIn config_

_Add SHA1 for Android and bundle ID for iOS_



### Run the app

_flutter run_
