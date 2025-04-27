# Chat App

A chat app developed with Firebase and Flutter.

Inspired by the design of Alex Hylton, design available at [Chatting App UI kit - Chatbox](https://www.figma.com/community/file/1152599900945065665).

#### This project has the objetive of:
- Try the Clean Architecture with Riverpod.
- Practice the login with Google using Firebase Auth.
- Try the login using email and password using Firebase Auth.
- Practice to replicate screens to the app by using a Figma project.
- Practice Firebase Firestore to store user, chats, messages and stories data.
- Try Firebase Storage to store media sent by users and Stories *(Used Cloudinary instead)*.

## Functionalities
- Users
    - Login with Google. 
    - Login and signup with email and password. 
- Friends Requests
    - Send friend requests to another accounts.
    - Accept or decline friend requests by another accounts.
- Chats
    - Send and receive text privately with friend.
    - Create groups with your friends.
    - Send and receive text messages in groups with friends.
    - Send media in private chats or groups. *(using cloudinary)*
- Messages
    - See if your friend saw your private message.
    - See who saw your message in the group.
- Stories
    - Post stories for friends.
    - List the stories of your friends.
    - Like your friends stories.
- App Language
    - Be able to change the app language.
    - Support English.
    - Support Brazilian Portuguese.
- App Theme
    - Be able to change the app theme mode.
    - Support light theme mode.
    - Support dark theme mode.
    - Support system theme mode.

## Screenshots

### Onboarding screen
<img src="screenshots/onboarding.png" alt="screenshot" width="200"/>

### Log in screen
<div style="display: flex; gap: 10px;">
    <img src="screenshots/login.png" alt="screenshot" width="200"/>
    <img src="screenshots/login_google.png" alt="screenshot" width="200"/>
</div>


### Sign in screen
<img src="screenshots/signup.png" alt="screenshot" width="200"/>

### Home screen
<img src="screenshots/home.png" alt="screenshot" width="200"/>

### Story screen
<img src="screenshots/story.png" alt="screenshot" width="200"/>

### Chat screen
<img src="screenshots/group_chat_image.png" alt="screenshot" width="200"/>

### New group screen
<img src="screenshots/new_group.png" alt="screenshot" width="200"/>

### Friends screen
<img src="screenshots/friends.png" alt="screenshot" width="200"/>

### Search friends and chats screen
<img src="screenshots/search.png" alt="screenshot" width="200"/>

### Settings screen
<img src="screenshots/settings.png" alt="screenshot" width="200"/>

### App settings screen
<div style="display: flex; gap: 10px;">
    <img src="screenshots/app_setting_theme.png" alt="screenshot" width="200"/>
    <img src="screenshots/app_setting_lang.png" alt="screenshot" width="200"/>
</div>

## Build

To build, you need to initialize the Firebase in the app with your own Firebase Project. For this, use [FlutterFire](https://firebase.flutter.dev/docs/cli/).

To make the media sending functionality to work, you must create an account on Cloudinary (It's free). After that, get the Cloud Name, API Key and API Secret and put in a *.env* file, in the project root, like that:

```bash
CLOUDINARY_CLOUD_NAME="abcde123"
CLOUDINARY_API_KEY="abcde123"
CLOUDINARY_API_SECRET="abcde123"
```

Finally, run the app pressing *F5* key on vscode, or with this command: 

```bash
flutter run
```