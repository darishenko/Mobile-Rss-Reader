class NewsItem {
  final String? title;
  final String? link;
  final DateTime publicationDate;

  NewsItem({
    required this.title,
    required this.link,
    required this.publicationDate,
  });

  comparer(NewsItem other) {
    return publicationDate.compareTo(other.publicationDate);
  }
}
