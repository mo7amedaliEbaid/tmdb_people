# TMDB Flutter Assessment — Full Project (Hive + UseCases + Bloc)

This document contains a complete, ready-to-copy Flutter project scaffold that implements the assessment using:
- `flutter_bloc` (state management)
- `go_router` (navigation)
- `flutter_screenutil` (responsiveness)
- `hive` + `hive_flutter` (offline caching & models)
- `intl` + `flutter_localizations` (localization scaffold)

It includes a generic API client, error handling, repository pattern, domain use-cases, a Cubit for popular people with infinite scroll, screens, widgets, and an image viewer with saving support.

---

## Important notes before using
1. Replace `YOUR_TMDB_API_KEY` in `lib/configs/api_config.dart`.
2. Run `flutter pub get`.
3. Run `flutter packages pub run build_runner build --delete-conflicting-outputs` to generate Hive adapters (`person_model.g.dart`).
4. Register the generated adapter in `main.dart` and open the Hive box.

---

## pubspec.yaml
```yaml
name: tmdb_assessment
description: TMDB assessment app
publish_to: "none"
version: 0.1.0+1
environment:
sdk: ">=2.18.0 <3.0.0"
dependencies:
flutter:
sdk: flutter
cupertino_icons: ^1.0.2
flutter_bloc: ^8.1.2
go_router: ^7.0.0
flutter_screenutil: ^5.7.0
http: ^0.13.6
hive: ^2.2.3
hive_flutter: ^1.1.0
path_provider: ^2.0.14
intl: ^0.18.0
flutter_localizations:
sdk: flutter
cached_network_image: ^3.2.3
permission_handler: ^10.4.0
image_gallery_saver: ^1.7.1
dev_dependencies:
flutter_test:
sdk: flutter
build_runner: ^2.4.6
hive_generator: ^1.1.4
```

---