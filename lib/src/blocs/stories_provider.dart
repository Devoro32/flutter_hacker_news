import 'package:flutter/material.dart';
import 'package:hnews/src/blocs/stories_bloc.dart';
export 'package:hnews/src/blocs/stories_bloc.dart'; //267

//263
//Linking the StoriesBloc to the stories provider
class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({required Key? key, required Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static StoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>(
            aspect: StoriesProvider))!
        .bloc;
  }
}//end of StoriesProvider
