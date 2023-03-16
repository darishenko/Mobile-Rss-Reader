import 'dart:io';

import 'package:http/io_client.dart';
import 'package:webfeed/domain/rss_feed.dart';
import '../model/news_item.dart';

Future<List<NewsItem>> getNewsItems(String url) async {
  final client = IOClient(HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true));

  var response = await client.get(Uri.parse(url));
  var channel = RssFeed.parse(response.body);

  List<NewsItem> newsItems = [];
  for (var i = 0; i < channel.items!.length; i++) {
    var item = channel.items![i];
    var newsItem = NewsItem(
        title: item.title,
        link: item.link,
        publicationDate: item.pubDate!);
    newsItems.add(newsItem);
  }
  return newsItems;
}

Future<String> getUrlTitle(String url) async {
  final client = IOClient(HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true));

  var response = await client.get(Uri.parse(url));
  var channel = RssFeed.parse(response.body);
  return channel.title!;
}
