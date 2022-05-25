import 'package:flutter/material.dart';
import 'package:hacker_news/model/feed_item.dart';
import 'package:hacker_news/repository/hacker_news_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

part 'hacker_news_store.g.dart';

enum FeedType { latest, top }

class HackerNewsStore = _HackerNewsStore with _$HackerNewsStore;

abstract class _HackerNewsStore with Store {
  final HackerNewsRepository _hackerNewsRepository = HackerNewsRepository();

  @observable
  ObservableFuture<List<FeedItem>>? latestItemsFuture;

  @observable
  ObservableFuture<List<FeedItem>>? topItemsFuture;

  @action
  Future fetchLatest() =>
      latestItemsFuture = ObservableFuture(_hackerNewsRepository.newest());

  @action
  Future fetchTop() =>
      topItemsFuture = ObservableFuture(_hackerNewsRepository.top());

  void loadNews(FeedType type) {
    if (type == FeedType.latest && latestItemsFuture == null) {
      fetchLatest();
    } else if (type == FeedType.top && topItemsFuture == null) {
      fetchTop();
    }
  }

  void openUrl(String? url) async {
    Uri uri = Uri.parse(url ?? '');

    canLaunchUrl(uri).then((bool result) {
      if (result == true) {
        launchUrl(uri);
      } else {
        debugPrint('Could not open $url');
      }
    });
  }

  Future refresh(FeedType type) =>
      (type == FeedType.latest) ? fetchLatest() : fetchTop();
}
