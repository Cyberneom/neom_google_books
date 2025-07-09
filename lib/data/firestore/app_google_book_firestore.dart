import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/data/firestore/constants/app_firestore_collection_constants.dart';
import 'package:neom_core/domain/model/app_media_item.dart';
import 'package:neom_core/domain/model/item_list.dart';
import 'package:neom_core/utils/enums/app_media_source.dart';
import 'package:neom_core/utils/enums/media_item_type.dart';

class AppGoogleBookFirestore {

  final appGoogleBookReference = FirebaseFirestore.instance.collection(AppFirestoreCollectionConstants.googleBooks);
  final profileReference = FirebaseFirestore.instance.collectionGroup(AppFirestoreCollectionConstants.profiles);

  Future<AppMediaItem> retrieve(String itemId) async {
    AppConfig.logger.d("Getting item $itemId");
    AppMediaItem appMediaItem = AppMediaItem();
    try {
      await appGoogleBookReference.doc(itemId).get().then((doc) {
        if (doc.exists) {
          appMediaItem = AppMediaItem.fromJSON(jsonEncode(doc.data()));
          AppConfig.logger.d("AppMediaItem ${appMediaItem.name} was retrieved with details");
        } else {
          AppConfig.logger.d("AppMediaItem not found");
        }
      });
    } catch (e) {
      AppConfig.logger.d(e);
      rethrow;
    }
    return appMediaItem;
  }

  Future<Map<String, AppMediaItem>> fetchAll({ int minItems = 0, int maxLength = 100,
    MediaItemType? type, List<MediaItemType>? excludeTypes}) async {
    AppConfig.logger.t("Getting appMediaItems from list");

    Map<String, AppMediaItem> appMediaItems = {};

    try {
      QuerySnapshot querySnapshot = await appGoogleBookReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        AppConfig.logger.t("QuerySnapshot is not empty");
        for (var documentSnapshot in querySnapshot.docs) {
          AppMediaItem appMediaItem = AppMediaItem.fromJSON(documentSnapshot.data());
          if(appMediaItem.name.toLowerCase() == 'no se vaya a confundir - en vivo') {
            AppConfig.logger.i("Add ${appMediaItem.name} Debuggin next");
          }
          appMediaItem.id = documentSnapshot.id;
          if((type == null || appMediaItem.type == type)
              && (excludeTypes == null || !excludeTypes.contains(appMediaItem.type))) {
            appMediaItems[appMediaItem.id] = appMediaItem;
          }
          AppConfig.logger.t("Add ${appMediaItem.name} to fetchAll list");
        }
      }
    } catch (e) {
      AppConfig.logger.d(e);
    }
    return appMediaItems;
  }

  Future<Map<String, AppMediaItem>> retrieveFromList(List<String> appMediaItemIds) async {
    AppConfig.logger.t("Getting ${appMediaItemIds.length} appMediaItems from firestore");

    Map<String, AppMediaItem> appMediaItems = {};

    try {
      QuerySnapshot querySnapshot = await appGoogleBookReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var documentSnapshot in querySnapshot.docs) {
          if(appMediaItemIds.contains(documentSnapshot.id)){
            AppMediaItem appMediaItemm = AppMediaItem.fromJSON(documentSnapshot.data());
            AppConfig.logger.d("AppMediaItem ${appMediaItemm.name} was retrieved with details");
            appMediaItems[documentSnapshot.id] = appMediaItemm;
          }
        }
      }

    } catch (e) {
      AppConfig.logger.d(e);
    }
    return appMediaItems;
  }

  Future<bool> exists(String appMediaItemId) async {
    AppConfig.logger.d("Getting appMediaItem $appMediaItemId");

    try {
      await appGoogleBookReference.doc(appMediaItemId).get().then((doc) {
        if (doc.exists) {
          AppConfig.logger.d("AppMediaItem found");
          return true;
        }
      });
    } catch (e) {
      AppConfig.logger.e(e);
    }
    AppConfig.logger.d("AppMediaItem not found");
    return false;
  }

  Future<void> insert(AppMediaItem appMediaItem) async {
    AppConfig.logger.t("Adding appMediaItem to database collection");
    try {
      if((!appMediaItem.url.contains("gig-me-out") && !appMediaItem.url.contains("gigmeout")
          && !appMediaItem.url.contains("firebasestorage.googleapis.com")) && appMediaItem.mediaSource == AppMediaSource.internal) {
        if(appMediaItem.url.contains("spotify") || appMediaItem.url.contains("p.scdn.co")) {
          appMediaItem.mediaSource = AppMediaSource.spotify;
        } else if(appMediaItem.url.contains("youtube")) {
          appMediaItem.mediaSource = AppMediaSource.youtube;
        } else {
          appMediaItem.mediaSource = AppMediaSource.other;
        }
    }

      await appGoogleBookReference.doc(appMediaItem.id).set(appMediaItem.toJSON());
      AppConfig.logger.d("AppMediaItem inserted into Firestore");
    } catch (e) {
      AppConfig.logger.e(e.toString());
      AppConfig.logger.i("AppMediaItem not inserted into Firestore");
    }
  }

  Future<bool> remove(AppMediaItem appMediaItem) async {
    AppConfig.logger.d("Removing appMediaItem from database collection");
    try {
      await appGoogleBookReference.doc(appMediaItem.id).delete();
      return true;
    } catch (e) {
      AppConfig.logger.d(e.toString());
      return false;
    }
  }

  Future<bool> removeItemFromList(String profileId, String itemlistId, AppMediaItem appMediaItem) async {
    AppConfig.logger.d("Removing ItemlistItem for user $profileId");

    try {

      await profileReference.get()
          .then((querySnapshot) async {
        for (var document in querySnapshot.docs) {
          if(document.id == profileId) {
            DocumentSnapshot snapshot  = await document.reference.collection(AppFirestoreCollectionConstants.itemlists)
                .doc(itemlistId).get();

            Itemlist itemlist = Itemlist.fromJSON(snapshot.data());
            itemlist.appMediaItems?.removeWhere((element) => element.id == appMediaItem.id);
            await document.reference.collection(AppFirestoreCollectionConstants.itemlists)
                .doc(itemlistId).update(itemlist.toJSON());

          }
        }
      });

      AppConfig.logger.i("ItemlistItem ${appMediaItem.name} was updated to ${appMediaItem.state}");
      return true;
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    AppConfig.logger.d("ItemlistItem ${appMediaItem.name} was not updated");
    return false;
  }

  Future<void> existsOrInsert(AppMediaItem appMediaItem) async {
    AppConfig.logger.t("existsOrInsert appMediaItem ${appMediaItem.id}");

    try {
      appGoogleBookReference.doc(appMediaItem.id).get().then((doc) {
        if (doc.exists) {
          AppConfig.logger.t("AppMediaItem found");
        } else {
          AppConfig.logger.d("AppMediaItem ${appMediaItem.id}. ${appMediaItem.name} not found. Inserting");
          insert(appMediaItem);
        }
      });
    } catch (e) {
      AppConfig.logger.e(e);
    }

  }

}
