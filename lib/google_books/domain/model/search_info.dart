
class SearchInfo {

  SearchInfo({
    String? textSnippet,
  }) {
    _textSnippet = textSnippet;
  }

  SearchInfo.fromJSON(dynamic json) {
    _textSnippet = json['textSnippet'];
  }
  String? _textSnippet;
  SearchInfo copyWith({
    String? textSnippet,
  }) =>
      SearchInfo(
        textSnippet: textSnippet ?? _textSnippet,
      );
  String? get textSnippet => _textSnippet;

  Map<String, dynamic> toJSON() {
    final map = <String, dynamic>{};
    map['textSnippet'] = _textSnippet;
    return map;
  }
}
