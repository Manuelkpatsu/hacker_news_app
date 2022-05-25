import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../model/feed_item.dart';
import '../store/hacker_news_store.dart';

class FeedItemsView extends StatelessWidget {
  const FeedItemsView(this.store, this.type, {Key? key}) : super(key: key);

  final HackerNewsStore store;
  final FeedType type;

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          final future = type == FeedType.latest
              ? store.latestItemsFuture
              : store.topItemsFuture;

          if (future == null) {
            return const CircularProgressIndicator();
          }

          switch (future.status) {
            case FutureStatus.pending:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text('Loading items...'),
                ],
              );

            case FutureStatus.rejected:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Failed to load items.',
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    child: const Text('Tap to try again'),
                    onPressed: () => store.refresh(type),
                  )
                ],
              );

            case FutureStatus.fulfilled:
              final List<FeedItem> items = future.result;
              return RefreshIndicator(
                onRefresh: () => store.refresh(type),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Text(
                        '${item.score}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: item.type != null
                          ? Text('- ${item.type}')
                          : Container(),
                      onTap: () => store.openUrl(item.url),
                    );
                  },
                ),
              );
          }
        },
      );
}
