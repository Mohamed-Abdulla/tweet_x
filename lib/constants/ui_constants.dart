import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tweet_x/constants/assets_constants.dart';
import 'package:tweet_x/features/tweet/widgets/tweet_list.dart';
import 'package:tweet_x/theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    const Text('Search'),
    const Text('Notification'),
  ];
}
