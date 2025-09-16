import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../configs/api_config.dart';
import '../../core/colors.dart';
import '../../core/styles.dart';
import '../../domain/entities/person_image.dart';
import '../blocs/person_details/person_details_bloc.dart';
import '../blocs/person_images/person_images_bloc.dart';

class PersonDetailsScreen extends StatefulWidget {
  final int personId;

  const PersonDetailsScreen({required this.personId, super.key});

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PersonDetailsBloc>().add(
      FetchPersonDetails(personId: widget.personId),
    );
    context.read<PersonImagesBloc>().add(
      FetchPersonImages(personId: widget.personId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: BlocBuilder<PersonDetailsBloc, PersonDetailsState>(
          builder: (context, state) {
            if (state is PersonDetailsLoaded) {
              return Text(
                state.details.name,
                style: AppStyles.titleLarge.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              );
            }
            return Text(
              'Details',
              style: AppStyles.titleLarge.copyWith(
                color: AppColors.textOnPrimary,
              ),
            );
          },
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: BlocBuilder<PersonDetailsBloc, PersonDetailsState>(
        builder: (context, detailsState) {
          return BlocBuilder<PersonImagesBloc, PersonImagesState>(
            builder: (context, imagesState) {
              if (detailsState is PersonDetailsLoading ||
                  imagesState is PersonImagesLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (detailsState is PersonDetailsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: AppStyles.iconXLarge,
                        color: AppColors.error,
                      ),
                      SizedBox(height: AppStyles.spacing16),
                      Text(
                        'Error: ${detailsState.message}',
                        style: AppStyles.bodyLarge.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppStyles.spacing24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PersonDetailsBloc>().add(
                            FetchPersonDetails(personId: widget.personId),
                          );
                        },
                        style: AppStyles.primaryButton,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (imagesState is PersonImagesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: AppStyles.iconXLarge,
                        color: AppColors.error,
                      ),
                      SizedBox(height: AppStyles.spacing16),
                      Text(
                        'Error loading images: ${imagesState.message}',
                        style: AppStyles.bodyLarge.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppStyles.spacing24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PersonImagesBloc>().add(
                            FetchPersonImages(personId: widget.personId),
                          );
                        },
                        style: AppStyles.primaryButton,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final details = detailsState is PersonDetailsLoaded
                  ? detailsState.details
                  : null;
              final images = imagesState is PersonImagesLoaded
                  ? imagesState.images
                  : <PersonImage>[];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (images.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppStyles.spacing16,
                        ),
                        child: Text(
                          'Photos',
                          style: AppStyles.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: AppStyles.spacing12),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppStyles.spacing16,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: AppStyles.spacing8,
                                mainAxisSpacing: AppStyles.spacing8,
                              ),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final img =
                                '${ApiConfig.imageBaseUrl}${images[index].filePath}';
                            return GestureDetector(
                              onTap: () =>
                                  GoRouter.of(context).push('/image?url=$img'),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppStyles.radiusMedium,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadowLight,
                                      blurRadius: 4.r,
                                      offset: Offset(0, 2.h),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppStyles.radiusMedium,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: img,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: AppColors.grey200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: AppColors.grey200,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: AppColors.grey500,
                                            size: AppStyles.iconLarge,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    if (details != null) ...[
                      Container(
                        margin: EdgeInsets.all(AppStyles.spacing16),
                        padding: EdgeInsets.all(AppStyles.spacing20),
                        decoration: AppStyles.cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Biography',
                              style: AppStyles.titleMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: AppStyles.spacing12),
                            Text(
                              details.biography ?? 'No biography available',
                              style: AppStyles.bodyLarge,
                            ),
                            if (details.birthday != null) ...[
                              SizedBox(height: AppStyles.spacing16),
                              _buildInfoRow('Birthday', details.birthday!),
                            ],
                            if (details.placeOfBirth != null) ...[
                              SizedBox(height: AppStyles.spacing8),
                              _buildInfoRow(
                                'Place of Birth',
                                details.placeOfBirth!,
                              ),
                            ],
                            if (details.knownForDepartment != null) ...[
                              SizedBox(height: AppStyles.spacing8),
                              _buildInfoRow(
                                'Known For',
                                details.knownForDepartment!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: AppStyles.spacing32),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            '$label:',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Text(value, style: AppStyles.bodyMedium)),
      ],
    );
  }
}
