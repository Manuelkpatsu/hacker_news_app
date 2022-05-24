import 'package:equatable/equatable.dart';

class FeedItem extends Equatable {
  final int score;
  final String title;
  final String? url;
  final String? type;

  const FeedItem(this.score, this.title, this.url, this.type);

  FeedItem.fromJson(Map<String, dynamic> json)
      : score = json['score'],
        title = json['title'],
        url = json['url'],
        type = json['type'];

  @override
  List<Object?> get props => [score, title, url, type];
}
