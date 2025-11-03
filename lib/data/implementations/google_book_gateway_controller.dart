import 'dart:async';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/domain/model/external_item.dart';
import 'package:neom_core/domain/use_cases/google_book_gateway_service.dart';
import 'package:neom_google_books/data/api_services/google_books_api.dart';
import 'package:neom_google_books/domain/model/google_book.dart';
import 'package:neom_google_books/utils/google_book_mapper.dart';

class GoogleBookGatewayController implements GoogleBookGatewayService {

  @override
  Future<Map<String, ExternalItem>> searchBooksAsExternalItem(String param) async {
    AppConfig.logger.t("GoogleBookGatewayController - searchBooksAsExternalItem - param: $param");

    Map<String, ExternalItem> externalItems = {};
    List<GoogleBook> googleBooks = await GoogleBooksAPI.searchBooks(param);
    for (var googleBook in googleBooks) {
      ExternalItem book = GoogleBookMapper.toExternalItem(googleBook);
      externalItems[book.id] = book;
    }

    return externalItems;
  }

}
