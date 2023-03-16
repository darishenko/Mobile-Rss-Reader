import '../model/news_item.dart';

List<NewsItem> findByNewsItemTitle(
    List<NewsItem> newsItems, String searchString) {
  List<NewsItem> foundedNewsItems = [];

  for (int i = 0; i < newsItems.length; i++) {
    if (newsItems[i]
        .title
        .toString()
        .toLowerCase()
        .contains(searchString.toLowerCase().trim())) {
      foundedNewsItems.add(newsItems[i]);
    }
  }
  return foundedNewsItems;
}

List<NewsItem> sortNewsItemsList(List<NewsItem> newsItemsList) {
  newsItemsList.sort((a, b) => b.comparer(a));
  return newsItemsList;
}
