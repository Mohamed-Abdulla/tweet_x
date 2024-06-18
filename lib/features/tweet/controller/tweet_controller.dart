import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweet_x/apis/storage_api.dart';
import 'package:tweet_x/apis/tweet_api.dart';
import 'package:tweet_x/core/enums/tweet_type_enum.dart';
import 'package:tweet_x/core/utils.dart';
import 'package:tweet_x/features/auth/controller/auth_controller.dart';
import 'package:tweet_x/models/tweet_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
        ref: ref,
        tweetAPI: ref.watch(tweetAPIProvider),
        storageAPI: ref.watch(storageAPIProvider));
  },
);

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController(
      {required Ref ref,
      required TweetAPI tweetAPI,
      required StorageAPI storageAPI})
      : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _ref = ref,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "Please enter text!");
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context);
    } else {
      _shareTextTweet(text: text, context: context);
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    String link = _getLinkFromText(text);
    final hashtags = _getHashtagsFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
    );

    final res = await _tweetAPI.shareTweet(tweet);

    res.fold((l) => showSnackBar(context, l.message), (r) => res);
    state = false;
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    String link = _getLinkFromText(text);
    final hashtags = _getHashtagsFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text) {
    List<String> wordsInSentence = text.split(" ");
    String link = "";
    for (String word in wordsInSentence) {
      if (word.startsWith("https://") || word.startsWith("www.")) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> wordsInSentence = text.split(" ");
    List<String> hashtags = [];
    for (String word in wordsInSentence) {
      if (word.startsWith("#")) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
