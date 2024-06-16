import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweet_x/constants/appwrite_constants.dart';
import 'package:tweet_x/core/providers.dart';

//now create provider for the storage api
final storageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appwriteStorageProvider));
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  //upload the image to the storage,
  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    //loop through the images and upload them to the storage
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
          bucketId: AppwriteConstants.imagesBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: file.path));
      imageLinks.add(AppwriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
