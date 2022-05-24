import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/feed_item.dart';

enum Type { newest, top }

extension on Type {
  Uri get uri {
    switch (this) {
      case Type.newest:
        return Uri.parse(
            'https://hacker-news.firebaseio.com/v0/newstories.json');

      case Type.top:
        return Uri.parse(
            'https://hacker-news.firebaseio.com/v0/topstories.json');
    }
  }
}

class HackerNewsRepository {
  Future<List<FeedItem>> newest() async {
    final ids = await _getItems(Type.newest);
    final items = await Future.wait(ids.map(_getItem));

    return items.toList(growable: false);
  }

  Future<List<FeedItem>> top() async {
    final ids = await _getItems(Type.top);
    final items = await Future.wait(ids.map(_getItem));

    return items.toList(growable: false);
  }

  Future<FeedItem> _getItem(int id) async {
    final response = await http
        .get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json'));
    Map<String, dynamic> data = jsonDecode(response.body);

    return FeedItem.fromJson(data);
  }

  Future<List<int>> _getItems(Type type, {int count = 25}) async {
    final response = await http.get(type.uri);

    final ids = (jsonDecode(response.body) as List)
        .take(count)
        .map((e) => e as int)
        .toList(growable: false);

    return ids;
  }
}
