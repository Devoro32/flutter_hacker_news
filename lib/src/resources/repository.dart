import 'dart:async';
import 'package:hnews/src/resources/news_api_provider.dart';

import 'package:hnews/src/resources/news_db_provider.dart';
import 'package:hnews/src/models/item_model.dart';

class Repository {
  //NewsApiProvider apiProvider = NewsApiProvider();
  //NewsDbProvider dbProvider = NewsDbProvider();

  //253
  //With the sources, it will go down the list to determine if that sources has the required item
  List<Source> sources = <Source>[
    //NewsDbProvider(),
    newsDbProvider, //255 create one instance of newsDBPROVIDER,
    //because we were calling it tiwice via sources and caches.
    NewsApiProvider()
  ];

  List<Cache> caches = <Cache>[
    //NewsDbProvider(),
    newsDbProvider, //255 create one instance of newsDBPROVIDER
  ];

  Future<List<int>> fetchTopIds() {
    return sources[1]
        // need to be 0 so it return the fetchTopIds from  newsAPI rather than db
        .fetchTopIds(); //257 we create fetchTopId that always gives null
  }

  Future<ItemModel> fetchItem(int id) async {
    /*254
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    item = await apiProvider.fetchItem(id);
    dbProvider.addItem(item);

    return item;
  }
  */
    late ItemModel item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item.id != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  } //fetchItem
} //end of repository class

//abstract classess

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}
