const _allowedImageHosts = {
  'images.unsplash.com',
  'picsum.photos',
};

/// Returns true when the URL belongs to a supported provider.
bool isAllowedImageUrl(String url) {
  final trimmed = url.trim();
  if (!(trimmed.startsWith('http://') || trimmed.startsWith('https://'))) {
    return false;
  }
  final host = Uri.tryParse(trimmed)?.host ?? '';
  return _allowedImageHosts.any(host.contains);
}

/// Generates stable fallback URLs using Picsum.
List<String> seededPicsumUrls(String seed, {int count = 3}) {
  final normalized = seed.trim().isEmpty ? 'personapath' : seed.trim();
  return List<String>.generate(count, (index) {
    final suffix = index == 0 ? '' : '${index + 1}';
    return 'https://picsum.photos/seed/${Uri.encodeComponent('$normalized$suffix')}/800/600';
  });
}
