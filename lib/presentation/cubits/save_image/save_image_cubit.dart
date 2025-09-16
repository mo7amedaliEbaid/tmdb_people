import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

part 'save_image_state.dart';

class SaveImageCubit extends Cubit<SaveImageState> {
  SaveImageCubit() : super(SaveImageInitial());

  Future<void> saveImage(String imageUrl) async {
    emit(SaveImageLoading());
    try {
      final res = await http.get(Uri.parse(imageUrl));
      final bytes = Uint8List.fromList(res.bodyBytes);

      final result = await ImageGallerySaver.saveImage(bytes);
      emit(SaveImageSuccess(result.toString()));
    } catch (e) {
      emit(SaveImageFailure(e.toString()));
    }
  }
}
