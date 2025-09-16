import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

typedef SaveImageFn =
    Future<dynamic> Function(Uint8List imageBytes, {int quality, String? name});
