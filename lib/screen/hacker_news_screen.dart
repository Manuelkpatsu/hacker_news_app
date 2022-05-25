import 'package:flutter/material.dart';
import 'package:hacker_news/widgets/feed_items_view.dart';

import '../store/hacker_news_store.dart';

class HackerNewsScreen extends StatefulWidget {
  const HackerNewsScreen({Key? key}) : super(key: key);

  @override
  _HackerNewsScreenState createState() => _HackerNewsScreenState();
}

class _HackerNewsScreenState extends State<HackerNewsScreen>
    with SingleTickerProviderStateMixin {
  final HackerNewsStore store = HackerNewsStore();

  late TabController _tabController;
  final _tabs = [FeedType.latest, FeedType.top];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() => store.loadNews(_tabs[_tabController.index]));

    store.loadNews(_tabs.first);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Hacker News'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Newest'), Tab(text: 'Top')],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              FeedItemsView(store, FeedType.latest),
              FeedItemsView(store, FeedType.top),
            ],
          ),
        ),
      );
}
