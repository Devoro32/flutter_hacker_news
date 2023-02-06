import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hnews/src/screens/news_list.dart';
import 'package:hnews/src/blocs/stories_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      key: null,
      child: const MaterialApp(
        title: 'News',
        home: NewsList(),
      ),
    );
  }
}
