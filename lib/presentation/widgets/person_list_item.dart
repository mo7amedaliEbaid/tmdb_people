import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../configs/api_config.dart';
import '../../core/colors.dart';
import '../../core/styles.dart';
import '../../data/models/person_model.dart';

class PersonListItem extends StatelessWidget {
  final PersonModel person;
  const PersonListItem({required this.person, super.key});

  @override
  Widget build(BuildContext context) {
    final profile = person.profilePath != null
        ? ApiConfig.imageBaseUrl + person.profilePath!
        : null;

    return Container(
      decoration: AppStyles.cardDecoration,
      margin: EdgeInsets.only(bottom: AppStyles.spacing8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => GoRouter.of(context).push('/person/${person.id}'),
          borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppStyles.spacing16),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.grey200,
                    backgroundImage: profile != null
                        ? CachedNetworkImageProvider(profile)
                        : null,
                    child: profile == null
                        ? Icon(
                            Icons.person,
                            size: AppStyles.iconLarge,
                            color: AppColors.grey500,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: AppStyles.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: AppStyles.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppStyles.spacing4),
                      Text(
                        'Actor',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: AppStyles.iconSmall,
                  color: AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
