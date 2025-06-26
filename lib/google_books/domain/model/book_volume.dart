import 'google_book.dart';

class BookVolume {

  String? kind;
  int? totalBooks;
  List<GoogleBook>? books;

  BookVolume({
    String? kind,
    int? totalBooks,
    List<GoogleBook>? books,
  });

  BookVolume.fromJSON(dynamic json) {
    kind = json['kind'];
    totalBooks = json['totalItems'];
    if (json['items'] != null) {
      books = [];
      json['items'].forEach((v) {
        books?.add(GoogleBook.fromJSON(v));
      });
    }
  }

  Map<String, dynamic> toJSON() {
    final map = <String, dynamic>{};
    map['kind'] = kind;
    map['totalItems'] = totalBooks;
    if (books != null) {
      map['items'] = books?.map((v) => v.toJSON()).toList();
    }
    return map;
  }

}
