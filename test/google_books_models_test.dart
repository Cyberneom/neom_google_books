// Tests para modelos POJO de neom_google_books:
// IndustryIdentifiers, ReadingModes, ImageLinks, SaleInfo.
// Patrón clásico Java-bean: getters + fromJSON + toJSON + copyWith.

import 'package:flutter_test/flutter_test.dart';
import 'package:neom_google_books/domain/model/image_links.dart';
import 'package:neom_google_books/domain/model/industry_identifiers.dart';
import 'package:neom_google_books/domain/model/reading_modes.dart';
import 'package:neom_google_books/domain/model/sale_info.dart';

void main() {
  group('IndustryIdentifiers', () {
    test('constructor con nulls', () {
      final ids = IndustryIdentifiers();
      expect(ids.type, isNull);
      expect(ids.identifier, isNull);
    });

    test('constructor con valores', () {
      final ids = IndustryIdentifiers(
        type: 'ISBN_13',
        identifier: '9780000000001',
      );
      expect(ids.type, 'ISBN_13');
      expect(ids.identifier, '9780000000001');
    });

    test('round-trip JSON', () {
      final original = IndustryIdentifiers(
        type: 'ISBN_10',
        identifier: '0123456789',
      );
      final restored = IndustryIdentifiers.fromJSON(original.toJSON());
      expect(restored.type, 'ISBN_10');
      expect(restored.identifier, '0123456789');
    });

    test('copyWith reemplaza solo el type', () {
      final original = IndustryIdentifiers(type: 'ISBN_10', identifier: 'X');
      final copy = original.copyWith(type: 'ISBN_13');
      expect(copy.type, 'ISBN_13');
      expect(copy.identifier, 'X');
    });

    test('toJSON incluye nulls (no excluyente)', () {
      final ids = IndustryIdentifiers();
      final map = ids.toJSON();
      expect(map.containsKey('type'), isTrue);
      expect(map['type'], isNull);
    });
  });

  group('ReadingModes', () {
    test('constructor con true/false', () {
      final modes = ReadingModes(text: true, image: false);
      expect(modes.text, isTrue);
      expect(modes.image, isFalse);
    });

    test('round-trip JSON', () {
      final original = ReadingModes(text: true, image: true);
      final restored = ReadingModes.fromJSON(original.toJSON());
      expect(restored.text, isTrue);
      expect(restored.image, isTrue);
    });

    test('copyWith preserva campos no especificados', () {
      final original = ReadingModes(text: true, image: false);
      final copy = original.copyWith(image: true);
      expect(copy.text, isTrue);
      expect(copy.image, isTrue);
    });
  });

  group('ImageLinks', () {
    test('constructor', () {
      final links = ImageLinks(
        smallThumbnail: 'https://x/s.jpg',
        thumbnail: 'https://x/t.jpg',
      );
      expect(links.smallThumbnail, 'https://x/s.jpg');
      expect(links.thumbnail, 'https://x/t.jpg');
    });

    test('round-trip JSON', () {
      final original = ImageLinks(
        smallThumbnail: 'https://x/s.jpg',
        thumbnail: 'https://x/t.jpg',
      );
      final restored = ImageLinks.fromJSON(original.toJSON());
      expect(restored.smallThumbnail, 'https://x/s.jpg');
      expect(restored.thumbnail, 'https://x/t.jpg');
    });

    test('fromJSON con campos null', () {
      final links = ImageLinks.fromJSON(<String, dynamic>{});
      expect(links.smallThumbnail, isNull);
      expect(links.thumbnail, isNull);
    });
  });

  group('SaleInfo', () {
    test('constructor', () {
      final info = SaleInfo(
        country: 'US',
        saleability: 'FOR_SALE',
        isEbook: true,
      );
      expect(info.country, 'US');
      expect(info.saleability, 'FOR_SALE');
      expect(info.isEbook, isTrue);
    });

    test('round-trip JSON', () {
      final original = SaleInfo(
        country: 'MX',
        saleability: 'NOT_FOR_SALE',
        isEbook: false,
      );
      final restored = SaleInfo.fromJSON(original.toJSON());
      expect(restored.country, 'MX');
      expect(restored.saleability, 'NOT_FOR_SALE');
      expect(restored.isEbook, isFalse);
    });

    test('copyWith parcial', () {
      final original = SaleInfo(country: 'US', saleability: 'FOR_SALE');
      final copy = original.copyWith(country: 'MX');
      expect(copy.country, 'MX');
      expect(copy.saleability, 'FOR_SALE');
    });
  });
}
