import 'package:flutter/material.dart';

import '../../core/constants.dart';

class SafeNetworkImage extends StatelessWidget {
  const SafeNetworkImage({
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    super.key,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final u = (url ?? '').trim();
    final isValid = u.startsWith('http://') || u.startsWith('https://');

    Widget child;
    if (!isValid) {
      child = _placeholder();
    } else {
      child = Image.network(
        u,
        headers: const {
          'User-Agent': 'Mozilla/5.0',
        },
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder();
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('SafeNetworkImage failed url=$u error=$error');
          return _placeholder();
        },
      );
    }

    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.lightGrey,
      alignment: Alignment.center,
      child: const Icon(Icons.image, color: AppColors.darkGrey),
    );
  }
}
