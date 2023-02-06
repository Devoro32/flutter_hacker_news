// ignore_for_file: public_member_api_docs, sort_constructors_first
//278
import 'package:flutter/material.dart';

import 'package:hnews/src/blocs/stories_provider.dart';
import 'package:hnews/src/models/item_model.dart';
//279
import 'dart:async';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({required this.itemId, super.key});
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

//279
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Stream still loading');
        } //280
        //! ERROR HERE- CAN'T LOAD FROM THE ITEM MODEL-251 &287
        return FutureBuilder(
          future: snapshot.data?[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Still loading $itemId');
            }
            //https://stackoverflow.com/questions/67659678/flutter-the-property-settings-cant-be-unconditionally-accessed-because-the
            return Text(itemSnapshot.data!.title);
          },
        );
      },
    );
  }
}
