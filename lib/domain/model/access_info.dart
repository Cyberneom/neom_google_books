
import 'epub_item.dart';
import 'pdf_item.dart';

class AccessInfo {
  AccessInfo({
    String? country,
    String? viewability,
    bool? embeddable,
    bool? publicDomain,
    String? textToSpeechPermission,
    Epub? epub,
    PdfItem? pdf,
    String? webReaderLink,
    String? accessViewStatus,
    bool? quoteSharingAllowed,
  }) {
    _country = country;
    _viewability = viewability;
    _embeddable = embeddable;
    _publicDomain = publicDomain;
    _textToSpeechPermission = textToSpeechPermission;
    _epub = epub;
    _pdf = pdf;
    _webReaderLink = webReaderLink;
    _accessViewStatus = accessViewStatus;
    _quoteSharingAllowed = quoteSharingAllowed;
  }

  AccessInfo.fromJSON(dynamic json) {
    _country = json['country'];
    _viewability = json['viewability'];
    _embeddable = json['embeddable'];
    _publicDomain = json['publicDomain'];
    _textToSpeechPermission = json['textToSpeechPermission'];
    _epub = json['epub'] != null ? Epub.fromJSON(json['epub']) : null;
    _pdf = json['pdf'] != null ? PdfItem.fromJSON(json['pdf']) : null;
    _webReaderLink = json['webReaderLink'];
    _accessViewStatus = json['accessViewStatus'];
    _quoteSharingAllowed = json['quoteSharingAllowed'];
  }
  String? _country;
  String? _viewability;
  bool? _embeddable;
  bool? _publicDomain;
  String? _textToSpeechPermission;
  Epub? _epub;
  PdfItem? _pdf;
  String? _webReaderLink;
  String? _accessViewStatus;
  bool? _quoteSharingAllowed;
  AccessInfo copyWith({
    String? country,
    String? viewability,
    bool? embeddable,
    bool? publicDomain,
    String? textToSpeechPermission,
    Epub? epub,
    PdfItem? pdf,
    String? webReaderLink,
    String? accessViewStatus,
    bool? quoteSharingAllowed,
  }) =>
      AccessInfo(
        country: country ?? _country,
        viewability: viewability ?? _viewability,
        embeddable: embeddable ?? _embeddable,
        publicDomain: publicDomain ?? _publicDomain,
        textToSpeechPermission:
            textToSpeechPermission ?? _textToSpeechPermission,
        epub: epub ?? _epub,
        pdf: pdf ?? _pdf,
        webReaderLink: webReaderLink ?? _webReaderLink,
        accessViewStatus: accessViewStatus ?? _accessViewStatus,
        quoteSharingAllowed: quoteSharingAllowed ?? _quoteSharingAllowed,
      );
  String? get country => _country;
  String? get viewability => _viewability;
  bool? get embeddable => _embeddable;
  bool? get publicDomain => _publicDomain;
  String? get textToSpeechPermission => _textToSpeechPermission;
  Epub? get epub => _epub;
  PdfItem? get pdf => _pdf;
  String? get webReaderLink => _webReaderLink;
  String? get accessViewStatus => _accessViewStatus;
  bool? get quoteSharingAllowed => _quoteSharingAllowed;

  Map<String, dynamic> toJSON() {
    final map = <String, dynamic>{};
    map['country'] = _country;
    map['viewability'] = _viewability;
    map['embeddable'] = _embeddable;
    map['publicDomain'] = _publicDomain;
    map['textToSpeechPermission'] = _textToSpeechPermission;
    if (_epub != null) {
      map['epub'] = _epub?.toJSON();
    }
    if (_pdf != null) {
      map['pdf'] = _pdf?.toJSON();
    }
    map['webReaderLink'] = _webReaderLink;
    map['accessViewStatus'] = _accessViewStatus;
    map['quoteSharingAllowed'] = _quoteSharingAllowed;
    return map;
  }
}
