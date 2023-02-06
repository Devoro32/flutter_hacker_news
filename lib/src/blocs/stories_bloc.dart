// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';

import 'package:hnews/src/models/item_model.dart';
import 'package:hnews/src/resources/repository.dart';

//modified because of 285
class StoriesBloc {
  //PublicSubject is from rxdart similar to streamcontroller
  final _topIds = PublishSubject<List<int>>();
  final _repository = Repository();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  // streamcontroller that everyone will listen to
  final _itemsFetcher = PublishSubject<int>();
  //stream controller that is accessable to the outside
  //world

//277- hold the reference to the transform stream => _items.stream.transform(_itemTransformer());
//https://stackoverflow.com/questions/67034475/non-nullable-instance-field-must-be-initialized
  //!late Stream<Map<int, Future<ItemModel>>> items; - no longer needed

// Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

//275- getter for the Sinks
  //!Function(int) get fetchItem => _items.sink.add;
  Function(int) get fetchItem => _itemsFetcher.sink.add;
//277

  StoriesBloc() {
    //we only want to apply the transformer once HENCE the constructor function
    //otherwise for each ids it call, will have their own transformer and caches
    //!nolonger need this since we dont need a transformer anymore
    //items = _items.stream.transform(_itemTransformer());
    //a new stream is returned from this line of code
    //!everything that comes into the itemsfetcher, we want to send it to the transformer
    _itemsFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

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

      (Map<int, Future<ItemModel>> cache, int id, index) {
        //274
        print(index);
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
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
