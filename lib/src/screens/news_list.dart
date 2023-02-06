import 'package:flutter/material.dart';
import 'package:hnews/src/blocs/stories_provider.dart';
import 'package:hnews/src/widgets/news_list_tile.dart';

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(
        context); //266, coming from the stories_provider 'of'
    bloc.fetchTopIds(); //267
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream:
          bloc.topIds, //topIds is coming from the stories_bloc, which is being
      //fetched from the repository and added to the stream

      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          //checking if snapshot'stream'  doesn't have data,
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
              backgroundColor: Colors.yellow,
            ),
          );
        }
        return ListView.builder(
          //267
          itemCount: snapshot.data?.length,
          itemBuilder: (context, int index) {
            //https://stackoverflow.com/questions/72699462/flutter-the-method-cant-be-unconditionally-invoked-because-the-receiver-ca
            bloc.fetchItem(snapshot.data![index]);
            //281
            return NewsListTile(
              itemId: snapshot.data![index],
            );
          },
        );
      },
    );
  }
}
