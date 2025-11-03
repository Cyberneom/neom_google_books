import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/data/firestore/constants/app_firestore_collection_constants.dart';
import 'package:neom_core/domain/model/external_item.dart';
import 'package:neom_core/domain/model/item_list.dart';

class AppGoogleBookFirestore {

  final appGoogleBookReference = FirebaseFirestore.instance.collection(AppFirestoreCollectionConstants.googleBooks);
  final profileReference = FirebaseFirestore.instance.collectionGroup(AppFirestoreCollectionConstants.profiles);

  Future<ExternalItem> retrieve(String itemId) async {
    AppConfig.logger.d("Getting item $itemId");
    ExternalItem externalItem = ExternalItem();
    try {
      await appGoogleBookReference.doc(itemId).get().then((doc) {
        if (doc.exists) {
          externalItem = ExternalItem.fromJSON(jsonEncode(doc.data()));
          AppConfig.logger.d("ExternalItem ${externalItem.name} was retrieved with details");
        } else {
          AppConfig.logger.d("ExternalItem not found");
        }
      });
    } catch (e) {
      AppConfig.logger.d(e);
      rethrow;
    }
    return externalItem;
  }

  Future<Map<String, ExternalItem>> fetchAll({ int minItems = 0, int maxLength = 100}) async {
    AppConfig.logger.t("Getting externalItems from list");

    Map<String, ExternalItem> externalItems = {};

    try {
      QuerySnapshot querySnapshot = await appGoogleBookReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        AppConfig.logger.t("QuerySnapshot is not empty");
        for (var documentSnapshot in querySnapshot.docs) {
          ExternalItem externalItem = ExternalItem.fromJSON(documentSnapshot.data());
          if(externalItem.name.toLowerCase() == 'no se vaya a confundir - en vivo') {
            AppConfig.logger.i("Add ${externalItem.name} Debuggin next");
          }
          externalItem.id = documentSnapshot.id;
          externalItems[externalItem.id] = externalItem;
          AppConfig.logger.t("Add ${externalItem.name} to fetchAll list");
        }
      }
    } catch (e) {
      AppConfig.logger.d(e);
    }
    return externalItems;
  }

  Future<Map<String, ExternalItem>> retrieveFromList(List<String> externalItemIds) async {
    AppConfig.logger.t("Getting ${externalItemIds.length} externalItems from firestore");

    Map<String, ExternalItem> externalItems = {};

    try {
      QuerySnapshot querySnapshot = await appGoogleBookReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var documentSnapshot in querySnapshot.docs) {
          if(externalItemIds.contains(documentSnapshot.id)){
            ExternalItem externalItemm = ExternalItem.fromJSON(documentSnapshot.data());
            AppConfig.logger.d("ExternalItem ${externalItemm.name} was retrieved with details");
            externalItems[documentSnapshot.id] = externalItemm;
          }
        }
      }

    } catch (e) {
      AppConfig.logger.d(e);
    }
    return externalItems;
  }

  Future<bool> exists(String externalItemId) async {
    AppConfig.logger.d("Getting externalItem $externalItemId");

    try {
      await appGoogleBookReference.doc(externalItemId).get().then((doc) {
        if (doc.exists) {
          AppConfig.logger.d("ExternalItem found");
          return true;
        }
      });
    } catch (e) {
      AppConfig.logger.e(e);
    }
    AppConfig.logger.d("ExternalItem not found");
    return false;
  }

  Future<void> insert(ExternalItem externalItem) async {
    AppConfig.logger.t("Adding externalItem to database collection");
    try {
      await appGoogleBookReference.doc(externalItem.id).set(externalItem.toJSON());
      AppConfig.logger.d("ExternalItem inserted into Firestore");
    } catch (e) {
      AppConfig.logger.e(e.toString());
      AppConfig.logger.i("ExternalItem not inserted into Firestore");
    }
  }

  Future<bool> remove(ExternalItem externalItem) async {
    AppConfig.logger.d("Removing externalItem from database collection");
    try {
      await appGoogleBookReference.doc(externalItem.id).delete();
      return true;
    } catch (e) {
      AppConfig.logger.d(e.toString());
      return false;
    }
  }

  Future<bool> removeItemFromList(String profileId, String itemlistId, ExternalItem externalItem) async {
    AppConfig.logger.d("Removing ItemlistItem for user $profileId");

    try {

      await profileReference.get()
          .then((querySnapshot) async {
        for (var document in querySnapshot.docs) {
          if(document.id == profileId) {
            DocumentSnapshot snapshot  = await document.reference.collection(AppFirestoreCollectionConstants.itemlists)
                .doc(itemlistId).get();

            Itemlist itemlist = Itemlist.fromJSON(snapshot.data());
            itemlist.externalItems?.removeWhere((element) => element.id == externalItem.id);
            await document.reference.collection(AppFirestoreCollectionConstants.itemlists)
                .doc(itemlistId).update(itemlist.toJSON());

          }
        }
      });

      AppConfig.logger.i("ItemlistItem ${externalItem.name} was updated to ${externalItem.state}");
      return true;
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    AppConfig.logger.d("ItemlistItem ${externalItem.name} was not updated");
    return false;
  }

  Future<void> existsOrInsert(ExternalItem externalItem) async {
    AppConfig.logger.t("existsOrInsert externalItem ${externalItem.id}");

    try {
      appGoogleBookReference.doc(externalItem.id).get().then((doc) {
        if (doc.exists) {
          AppConfig.logger.t("ExternalItem found");
        } else {
          AppConfig.logger.d("ExternalItem ${externalItem.id}. ${externalItem.name} not found. Inserting");
          insert(externalItem);
        }
      });
    } catch (e) {
      AppConfig.logger.e(e);
    }

  }

}
