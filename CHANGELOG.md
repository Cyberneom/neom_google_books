# Changelog

## 1.1.0
- Integrate SINT framework — migrate from deprecated GetX API
- Update SDK constraints to >=3.8.0

## 1.0.0
- Initial release with Google Books API integration
- Domain models: GoogleBook, BookVolume, VolumeInfo, SaleInfo, AccessInfo, ImageLinks, IndustryIdentifiers
- GoogleBooksApi service for search and retrieval
- AppGoogleBookFirestore for persistence
- GoogleBookGatewayController for orchestration
- GoogleBookMapper for API-to-domain data mapping
