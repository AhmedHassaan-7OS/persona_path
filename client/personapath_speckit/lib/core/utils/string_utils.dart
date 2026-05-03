/// Utility helpers for string-related application logic.
String resolveFallbackName(String? email, {String defaultName = 'Traveler'}) {
  final normalized = (email ?? '').trim();
  if (normalized.isEmpty) return defaultName;
  final atIndex = normalized.indexOf('@');
  if (atIndex <= 0) return defaultName;
  final username = normalized.substring(0, atIndex).trim();
  return username.isEmpty ? defaultName : username;
}
