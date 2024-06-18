import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweet_x/common/error_page.dart';
import 'package:tweet_x/common/loading_page.dart';
import 'package:tweet_x/features/tweet/controller/tweet_controller.dart';
import 'package:tweet_x/features/tweet/widgets/tweet_card.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.refresh(getTweetsProvider);
              },
              child: ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (BuildContext context, int index) {
                  final tweet = tweets[index];
                  return TweetCard(tweet: tweet);
                },
              ),
            );
          },
          error: (error, stacktrace) {
            print(error);
            print(stacktrace);

            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
