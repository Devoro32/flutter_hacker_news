// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';

import 'package:hnews/src/models/item_model.dart';
import 'package:hnews/src/resources/repository.dart';

class StoriesBloc {
  //PublicSubject is from rxdart similar to streamcontroller
  final _topIds = PublishSubject<List<int>>();
  final _repository = Repository();
  final _items =
      BehaviorSubject<int>(); // always going to be receiving an id that is int

//277- hold the reference to the transform stream => _items.stream.transform(_itemTransformer());
//https://stackoverflow.com/questions/67034475/non-nullable-instance-field-must-be-initialized
  late Stream<Map<int, Future<ItemModel>>> items;

// Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;

//275- getter for the Sinks
  Function(int) get fetchItem => _items.sink.add;

//277
  // /*
  StoriesBloc() {
    //we only want to apply the transformer once HENCE the constructor function
    //otherwise for each ids it call, will have their own transformer and caches
    items = _items.stream.transform(_itemTransformer());
    //a new stream is returned from this line of code
  }
//*/
  fetchTopIds() async {
    //265
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids); //add the ID from the URLS to the stream
  }

//273
//map cache to catch all the values
  _itemTransformer() {
    return ScanStreamTransformer(
      // function that get envoke everytime a new elements comes in
      // cache is the map that will store the ID, itemmodel
      //id is the id that will be coming into from the stream
      //index is the amount of time the function has been invoked....needs to be there but not to worry about

      (Map<int, Future<ItemModel>> cache, int id, _) {
        //274
        cache[id] = _repository.fetchItem(id);
        return cache;
      },

      //need the empty map and indicate the type of the map to add the argument to
      <int, Future<ItemModel>>{},
    );
  }

//always need to close the stream
  dispose() {
    _topIds.close();
    _items.close();
  }
}
