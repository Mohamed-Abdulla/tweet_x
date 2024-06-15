//we have common providers in this file which are used across the app

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweet_x/constants/constants.dart';

//provider from riverpod has ref which is used to get the value of the provider

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(
        status: true,
      );
});

final appwriteAccountProvider = Provider((ref) {
  //ref is used to interact with the provider using watch and read
  //watch continues to listen to the provider and read gets the value of the provider
  final client = ref.watch(
      appwriteClientProvider); //watch is used to get the value of the provider
  return Account(client);
});
