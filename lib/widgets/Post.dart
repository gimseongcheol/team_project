class Post {
  //final String imageUrl;
  final String title;
  final String content;
  final DateTime date;
  final int likeCount;

  Post({
    //required this.imageUrl,
    required this.title,
    required this.content,
    required this.date,
    this.likeCount = 0,
  });
}