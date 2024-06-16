import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tweet_x/constants/appwrite_constants.dart';
import 'package:tweet_x/core/core.dart';
import 'package:tweet_x/core/providers.dart';
import 'package:tweet_x/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
}

class TweetAPI implements ITweetAPI {
  //connect to db
  final Databases _db;
  //inject db through constructor
  TweetAPI({required Databases db}) : _db = db;
  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(), //generate unique id for each tweet
        data: tweet.toMap(),
      );

      return right(document);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection);

    return documents.documents;
  }
}
