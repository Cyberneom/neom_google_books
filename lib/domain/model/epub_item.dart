
class Epub {
  Epub({
    bool? isAvailable,
  }) {
    _isAvailable = isAvailable;
  }

  Epub.fromJSON(dynamic json) {
    _isAvailable = json['isAvailable'];
  }
  bool? _isAvailable;
  Epub copyWith({
    bool? isAvailable,
  }) =>
      Epub(
        isAvailable: isAvailable ?? _isAvailable,
      );
  bool? get isAvailable => _isAvailable;

  Map<String, dynamic> toJSON() {
    final map = <String, dynamic>{};
    map['isAvailable'] = _isAvailable;
    return map;
  }
}
