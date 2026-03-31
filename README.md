# neom_google_books

[![Maintained by Open Neom](https://img.shields.io/badge/Maintained%20by-Open%20Neom-blue)](https://openneom.dev)

Google Books API integration for the Open Neom ecosystem.

`neom_google_books` provides a clean, type-safe interface for searching and retrieving book data from the Google Books API, with Firestore persistence and domain model mapping for seamless integration within Open Neom applications.

---

### Explore the Open Neom Ecosystem
This package is part of the **Open Neom** modular suite.

* **Discover more modules:** [www.openneom.dev](https://www.openneom.dev)
* **Super App Architecture:** [Srznik](https://www.openneom.dev)

---

## Features & Responsibilities
* **Google Books API Integration:** Search and retrieve book volumes via `GoogleBooksApi`.
* **Firestore Persistence:** Store and query book data with `AppGoogleBookFirestore`.
* **Domain Models:** Rich models for book data — `GoogleBook`, `BookVolume`, `VolumeInfo`, `SaleInfo`, `AccessInfo`, `ImageLinks`, `IndustryIdentifiers`, and more.
* **Data Mapping:** `GoogleBookMapper` for converting API responses into Open Neom domain models.
* **Gateway Controller:** `GoogleBookGatewayController` orchestrates API calls and Firestore operations.

## Architecture

```
lib/
  data/
    api_services/       # Google Books API client
    firestore/          # Firestore CRUD operations
    implementations/    # Gateway controller
  domain/
    model/              # 13 domain models (GoogleBook, BookVolume, VolumeInfo, etc.)
  utils/
    google_book_mapper.dart  # API-to-domain mapping
```

## Dependencies
* `neom_core` — Core services, models, and Firestore utilities.

## License
This project is licensed under the Apache License, Version 2.0. See the LICENSE file for details.
