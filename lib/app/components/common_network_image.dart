import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CommonNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry borderRadius;
  final Color? backgroundColor;
  final bool showLoader;
  final Widget? loader;
  final Widget? errorWidget;
  final IconData errorIcon;
  final bool enableColorFilter;
  final Color filterColor;
  final BlendMode blendMode;
  final bool enableHero;
  final String? heroTag;
  final VoidCallback? onTap;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final Map<String, String>? httpHeaders;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final bool enableShimmer;

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.backgroundColor,
    this.showLoader = true,
    this.loader,
    this.errorWidget,
    this.errorIcon = Icons.broken_image_outlined,
    this.enableColorFilter = false,
    this.filterColor = Colors.black,
    this.blendMode = BlendMode.colorBurn,
    this.enableHero = false,
    this.heroTag,
    this.onTap,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.httpHeaders,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.memCacheWidth,
    this.memCacheHeight,
    this.enableShimmer = true,
  }) : assert(
          !enableHero || (enableHero && heroTag != null),
          'heroTag must be provided when enableHero is true',
        );

  @override
  Widget build(BuildContext context) {
    // Validate image URL
    if (imageUrl.isEmpty || !_isValidUrl(imageUrl)) {
      return _buildError();
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: httpHeaders,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 300),
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      imageBuilder: (context, imageProvider) => _buildImage(imageProvider),
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWithDetails(error),
      errorListener: (error) {
        // Log error for debugging
        debugPrint('CommonNetworkImage Error: $error for URL: $imageUrl');
      },
    );

    // Wrap with Hero if enabled
    if (enableHero && heroTag != null) {
      image = Hero(
        tag: heroTag!,
        transitionOnUserGestures: true,
        child: image,
      );
    }

    // Wrap with GestureDetector if onTap is provided
    if (onTap != null) {
      image = GestureDetector(
        onTap: onTap,
        child: image,
      );
    }

    return image;
  }

  /// Validates if the URL is properly formatted
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && 
             (uri.scheme == 'http' || 
              uri.scheme == 'https' || 
              uri.scheme == 'data');
    } catch (e) {
      return false;
    }
  }

  /// Builds the image with decoration and optional color filter
  Widget _buildImage(ImageProvider imageProvider) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            colorFilter: enableColorFilter
                ? ColorFilter.mode(
                    filterColor.withValues(alpha:0.2),
                    blendMode,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  /// Builds the loading placeholder
  Widget _buildPlaceholder() {
    if (!showLoader) return const SizedBox.shrink();

    if (loader != null) {
      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade100,
          borderRadius: borderRadius,
        ),
        child: loader,
      );
    }

    if (enableShimmer) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: borderRadius,
      ),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.grey.shade600,
        ),
      ),
    );
  }

  /// Builds error widget with error details
  Widget _buildErrorWithDetails(dynamic error) {
    if (errorWidget != null) return errorWidget!;
    return _buildError();
  }

  /// Builds the default error widget
  Widget _buildError() {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            errorIcon,
            color: Colors.grey.shade600,
            size: 32,
          ),
          if (width != null && width! > 100) ...[
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}