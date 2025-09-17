import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

part 'save_image_state.dart';

class SaveImageCubit extends Cubit<SaveImageState> {
  SaveImageCubit() : super(SaveImageInitial());

  final Dio _dio = Dio();

  Future<void> saveImage(String imageUrl) async {
    emit(SaveImageLoading());
    try {
      final response = await _dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data!);

      final result = await ImageGallerySaverPlus.saveImage(bytes);
      emit(SaveImageSuccess(result.toString()));
    } catch (e) {
      emit(SaveImageFailure(e.toString()));
    }
  }
}
