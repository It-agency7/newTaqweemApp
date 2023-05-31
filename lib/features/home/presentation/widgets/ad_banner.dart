import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/functions/launch_url.dart';
import '../../../../core/utils/values_manager.dart';

class AdBanner extends StatelessWidget {
  final String image;
  final String url;
  final bool withBorderRadius;
  const AdBanner({
    super.key,
    required this.image,
    required this.url,
    this.withBorderRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: withBorderRadius
          ? BorderRadius.circular(
              DistancesManager.cardBorderRadius,
            )
          : null,
      child: InkWell(
        onTap: () {
          launchUrl(url);
        },
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
