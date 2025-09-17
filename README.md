- 🎉 73 tests passed.   
- [![Test](https://github.com/mo7amedaliEbaid/tmdb_people/actions/workflows/test.yml/badge.svg)](https://github.com/mo7amedaliEbaid/tmdb_people/actions/workflows/test.yml)

## TMDB People — Small Project 
- Bloc 
- Clean Architecture 
- Unit/Widget Testing 
- Data Caching 
- Offline Mode 
- Download Network Image to Gallary)

## Demo Video


https://github.com/user-attachments/assets/4a4a545d-41fe-4e95-9cce-3b890e2d646d



### Main Dependencies
- `flutter_bloc` (state management)
- `dio` (Networking)
- `go_router` (navigation)
- `flutter_screenutil` (responsiveness)
- `hive` + `hive_flutter` (offline caching & models)
- `mockito` + `bloc_test` (Testing)

---

## Important notes before using
1. Replace `YOUR_TMDB_API_KEY` in `lib/configs/api_config.dart`.
2. Run `flutter pub get`.
3. Run `flutter packages pub run build_runner build --delete-conflicting-outputs` to generate Hive adapters.
4. Register the generated adapter in `main.dart` and open the Hive box.
## The App is tested on android and ios
---

## pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^8.1.2
  equatable: ^2.0.5
  go_router: ^7.0.0
  flutter_screenutil: ^5.7.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.0.14
  cached_network_image: ^3.2.3
  image_gallery_saver_plus:
  flutter_dotenv: ^5.1.0
  dio:
  connectivity_plus:
  pretty_dio_logger: ^1.4.0
  fluttertoast:


dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^5.0.0
  build_runner: ^2.4.6
  hive_generator: ^2.0.1
  mockito: ^5.4.4
  bloc_test: ^9.1.5
```

---
