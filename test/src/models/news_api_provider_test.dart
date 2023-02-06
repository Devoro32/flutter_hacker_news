import 'package:hnews/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:http/http.dart';
//download flutter pub add test --dev
import 'package:test/test.dart';
import 'package:http/testing.dart';

void main() {
  test('FetchTopIds return a list of ids', () async {
    //setup of test case
    //228
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4, 5]), 200);
    });

    final ids = await newsApi.fetchTopIds();
    //expectation
    expect(ids, [1, 2, 3, 4, 5]);
  });

/*  test('FetchItem return a item model', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });
    //999 just entering any number
    final item = newsApi.fetchItem(999);

    expect(item.id, 123);
  });
  */
}
//flutter test - to run flutter testing