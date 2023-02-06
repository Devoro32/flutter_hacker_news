import 'package:http/http.dart' show Client;

import 'dart:convert';
import 'package:hnews/src/models/item_model.dart';
import 'package:hnews/src/resources/repository.dart';

//251
class NewsApiProvider implements Source {
  //!This doesn't work to try to shorten the URL name
  //final String _root= 'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty';

  Client client = Client();
  var uri = Uri.parse('https://hacker-news.firebaseio.com/v0/topstories.json');

  @override
  Future<List<int>> fetchTopIds() async {
    final response = await client.get(uri);
    final ids = json.decode(response.body);
    return Future.delayed(
      const Duration(seconds: 2),
      () => ids.cast<int>(),
    );

    //adding the 2 second delay to see the progress bar
    // return ids.cast<int>();
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    var uri = Uri.parse(' https://hacker-news.firebaseio.com/v0/item/$id.json');
    final response = await client.get(uri);
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
