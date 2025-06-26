import 'package:neom_core/core/app_config.dart';
import 'package:neom_core/core/domain/model/app_media_item.dart';
import 'package:neom_core/core/domain/model/genre.dart';
import 'package:neom_core/core/utils/enums/app_media_source.dart';
import '../domain/model/google_book.dart';

class GoogleBookMapper {

  static AppMediaItem toAppMediaItem(GoogleBook googleBook) {

    AppMediaItem appItem = AppMediaItem();
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

      appItem =  AppMediaItem(
        id: googleBook.id ?? "",
        name: googleBook.volumeInfo?.title ?? "",
        album: googleBook.volumeInfo?.publisher ?? "",
        artist: authors,
        allImgs: [googleBook.volumeInfo?.imageLinks?.smallThumbnail ?? ""],
        duration: googleBook.volumeInfo?.pageCount ?? 0, ///NUMBER OF PAGES
        imgUrl: googleBook.volumeInfo?.imageLinks?.thumbnail ?? "",
        permaUrl: googleBook.volumeInfo?.infoLink ?? "",
        url: googleBook.volumeInfo?.previewLink ?? "",
        state: 0,
        genres: genres.map((e) => e.name).toList(),
        description: googleBook.volumeInfo?.description ?? "",
        mediaSource: AppMediaSource.google,
        publishedYear: 0, ///VERIFY HOW TO HANDLE THIS DATE TO SINCEEPOCH googleBook.volumeInfo?.publishedDate ?? ""
      );
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    return appItem;
  }

}
