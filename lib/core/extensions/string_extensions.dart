extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNullOrTrimEmpty => this == null || this!.trim().isEmpty;
}