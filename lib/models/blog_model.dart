class BlogModel {
  int id;
  String? title, cover, shortContent, content;
  DateTime? createdAt;
  int clickTimes;
  int likes;
  BlogMetaModel? meta;

  BlogModel(
    this.id, {
    this.clickTimes = 0,
    this.likes = 0,
    this.title,
    this.cover,
    this.content,
    this.createdAt,
    this.meta,
    this.shortContent,
  });

  static BlogModel fromMap(Map<String, dynamic> value) {
    return BlogModel(
      value['id'],
      title: value['title'],
      clickTimes: value['clickTimes'],
      likes: value['likes'],
      cover: value['cover'],
      content: value['content'],
      createdAt: DateTime.tryParse(value['createdAt']),
      shortContent: value['shortContent'],
      meta: BlogMetaModel.fromMap(value['meta'] as Map<String, dynamic>),
    );
  }
}

class BlogMetaModel {
  int readingTime;
  int wordCount;
  bool hasImages;
  List<String> images;

  BlogMetaModel({
    this.readingTime = 0,
    this.wordCount = 0,
    this.hasImages = false,
    this.images = const [],
  });

  static BlogMetaModel fromMap(Map<String, dynamic> value) {
    return BlogMetaModel(
      readingTime: value['readingTime'],
      wordCount: value['wordCount'],
      hasImages: value['hasImages'],
      images: List<String>.from(value['images']),
    );
  }
}
