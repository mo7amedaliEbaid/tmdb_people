import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/colors.dart';
import '../../core/styles.dart';
import '../cubits/save_image/save_image_cubit.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SaveImageCubit(),
      child: BlocListener<SaveImageCubit, SaveImageState>(
        listener: (context, state) {
          if (state is SaveImageSuccess) {
            Fluttertoast.showToast(
              msg: "Saved to gallery",
              textColor: AppColors.white,
              backgroundColor: AppColors.success,
            );
          } else if (state is SaveImageFailure) {
            Fluttertoast.showToast(
              msg: "Error: ${state.error}",
              textColor: AppColors.white,
              backgroundColor: AppColors.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.white,
            elevation: 0,
            actions: [
              BlocBuilder<SaveImageCubit, SaveImageState>(
                builder: (context, state) {
                  if (state is SaveImageLoading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  return IconButton(
                    icon: Icon(Icons.save_alt, size: AppStyles.iconMedium),
                    onPressed: () {
                      context.read<SaveImageCubit>().saveImage(imageUrl);
                    },
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: AppColors.grey900,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.grey900,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: AppStyles.iconXLarge,
                          color: AppColors.grey500,
                        ),
                        SizedBox(height: AppStyles.spacing16),
                        Text(
                          'Failed to load image',
                          style: AppStyles.bodyLarge.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
