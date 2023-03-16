// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:rss_reader.dart/model/news_item.dart';
import 'package:intl/intl.dart';
import 'package:rss_reader.dart/view/web_view.dart';

import '../service/news_feed_service.dart';
import '../service/rss_reader.dart';

class NewsFeed extends StatefulWidget {
  NewsFeed({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  TextEditingController searchingNewsItemTitle = TextEditingController();
  TextEditingController rssUrl = TextEditingController();

  String currentUrl = 'https://habr.com/ru/rss/hubs/all/';
  late String currentUrlTitle;
  late List<NewsItem> currentNewsItems;

  late bool isLoading;

  @override
  void initState() {
    super.initState();
    rssUrl.text = currentUrl;
    refreshNewsFeed();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshNewsFeed() async {
    setState(() => isLoading = true);
    currentNewsItems = [];
    rssUrl.text = currentUrl;
    currentNewsItems = await getNewsItems(currentUrl);
    currentUrlTitle = await getUrlTitle(currentUrl);
    if (searchingNewsItemTitle.text.isNotEmpty) {
      currentNewsItems = findByNewsItemTitle(
          currentNewsItems, searchingNewsItemTitle.text);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white30,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: TextField(
                controller: searchingNewsItemTitle,
                onChanged: (value) {
                  setState(() {
                    searchingNewsItemTitle == value;
                    refreshNewsFeed();
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                    ),
                    onPressed: () {
                      searchingNewsItemTitle.text = '';
                      refreshNewsFeed();
                    },
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                refreshNewsFeed();
              },
              icon: const Icon(
                Icons.refresh_sharp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Center(
          child: ListView.builder(
            itemCount: currentNewsItems.length,
            itemBuilder: (context, index) {
              final newsItem = currentNewsItems[index];
              return builtNewsItem(newsItem);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54,
          child: const Icon(
            Icons.newspaper_outlined,
            color: Colors.amberAccent,
            size: 50.0,
          ),
          onPressed: () => changeRssDialog(),
        ),
      );

  Widget builtNewsItem(NewsItem newsItem) => Builder(
        builder: (context) => Card(
          color: Colors.black54,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewWidget(url: newsItem.link)),
                    );
                  },
                  title: Text(
                    newsItem.title.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  textColor: Colors.white,
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '\n${DateFormat('yyyy-MM-dd – kk:mm').format(newsItem.publicationDate)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> changeRssDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Now open $currentUrlTitle'),
          titleTextStyle: const TextStyle(
            color: Colors.pink,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Please, write new rss url',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextField(
                  controller: rssUrl,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        rssUrl.text = '';
                      },
                    ),
                    hintText: 'Add...',
                    border: InputBorder.none,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Change',
                style: TextStyle(
                  color: Colors.pink,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                List<NewsItem> tempNews = await getNewsItems(rssUrl.text);
                if (tempNews.isNotEmpty) {
                  currentUrl = rssUrl.text;
                  refreshNewsFeed();
                } else {
                  rssUrl.text = currentUrl;
                }
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.pink,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                rssUrl.text = currentUrl;
              },
            ),
          ],
        );
      },
    );
  }
}
