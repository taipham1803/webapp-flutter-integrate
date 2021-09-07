# Example for integrate EMDDI webapp to Flutter project

A new Flutter project.

## Getting Started

git clone this repo

cd webapp-flutter-integrate && flutter pub get
flutter run

## How to auth webapp for production

### Use client app jwt to auth, parse jwt to webapp via url like

https://asim.emddi.xyz?token=$access_token

with access_token is your user's token

webapp will auto validate with auth server to get user's info like: name, phone, ...
