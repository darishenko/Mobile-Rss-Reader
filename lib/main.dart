import 'package:flutter/material.dart';
import 'package:rss_reader.dart/view/news_feed_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.black38,
    ),
    home: NewsFeed(),
  ));
}
