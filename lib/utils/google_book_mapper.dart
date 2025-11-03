import 'package:neom_core/app_config.dart';
import 'package:neom_core/domain/model/external_item.dart';
import 'package:neom_core/domain/model/genre.dart';
import 'package:neom_core/utils/enums/external_media_source.dart';
import 'package:neom_core/utils/enums/media_item_type.dart';
import '../domain/model/google_book.dart';

class GoogleBookMapper {

  static ExternalItem toExternalItem(GoogleBook googleBook) {

    ExternalItem externalItem = ExternalItem();
    List<Genre> genres = [];

    try {
      String authors = "";

      if(googleBook.volumeInfo?.authors?.isNotEmpty ?? false) {
        googleBook.volumeInfo?.authors?.forEach((element) {
          if(authors.isNotEmpty) {
            authors = "$authors, ";
          }

          if(authors.isEmpty) {
            authors = element;
          } else {
            authors = "$authors$element";
          }
        });
      }

      if(googleBook.volumeInfo?.categories?.isNotEmpty ?? false) {
        googleBook.volumeInfo?.categories?.forEach((element) {
          genres.add(Genre(id: element, name: element));
        });
      }

      externalItem =  ExternalItem(
        id: googleBook.id ?? "",
        name: googleBook.volumeInfo?.title ?? "",
        album: googleBook.volumeInfo?.publisher ?? "",
        ownerName: authors,
        galleryUrls: [googleBook.volumeInfo?.imageLinks?.smallThumbnail ?? ""],
        duration: googleBook.volumeInfo?.pageCount ?? 0, ///NUMBER OF PAGES
        imgUrl: googleBook.volumeInfo?.imageLinks?.thumbnail ?? "",
        permaUrl: googleBook.volumeInfo?.infoLink ?? "",
        url: googleBook.volumeInfo?.previewLink ?? "",
        state: 0,
        categories: genres.map((e) => e.name).toList(),
        description: googleBook.volumeInfo?.description ?? "",
        source: ExternalSource.google,
        publishedYear: 0, ///VERIFY HOW TO HANDLE THIS DATE TO SINCEEPOCH googleBook.volumeInfo?.publishedDate ?? ""
        type: MediaItemType.book
      );
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    return externalItem;
  }

}
