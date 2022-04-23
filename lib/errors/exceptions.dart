/// Defines an exception for when a requested resource is not found.
class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Defines an exception for when a stored resource is conflicting with the sent one.
class ConflictException implements Exception {
  final String message;
  const ConflictException(this.message);

  @override
  String toString() => 'ConflictException: $message';
}
