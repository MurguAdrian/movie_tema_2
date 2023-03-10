import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MoviePage(),
    );
  }
}

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    _getMovie();
  }

  final PageController controller = PageController(initialPage: 1);

  bool isLoading = true;
  bool x = true;

  final List<String> _title = <String>[];
  final List<String> _img = <String>[];
  final List<int> _years = <int>[];
  final List<int> _run = <int>[];
  final List<String> _datee = <String>[];

  void _getMovie() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json')).then((Response response) {
      response.body;

      final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
      final List<dynamic> movies = data['movies'] as List<dynamic>;

      setState(() {
        _title.addAll(movies.map((dynamic item) => item['title'] as String));
        _img.addAll(movies.map((dynamic item) => item["medium_cover_image"] as String));
        _years.addAll(movies.map((dynamic item) => item['year'] as int));
        _run.addAll(movies.map((dynamic item) => item["runtime"] as int));
        _datee.addAll(movies.map((dynamic item) => item["date_uploaded"] as String));

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (BuildContext context) {

          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return PageView.builder(

              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: _title.length,
              itemBuilder: (BuildContext, int index) {
                final String title = _title[index];
                final String img = _img[index];
                final int years = _years[index];
                final int run = _run[index];
                final String datee = _datee[index];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(child: Text('Now Showing'), onPressed: () {}),
                          TextButton(child: Text('Cinema'), onPressed: () {}),
                          TextButton(child: Text('Comming Soon'), onPressed: () {}),
                        ],
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 1.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
                        ),
                        alignment: Alignment.center,
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            child: Column(
                              children: [
                                ElevatedButton(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          color: Colors.tealAccent, fontSize: 25, fontStyle: FontStyle.italic),
                                    ),
                                    onPressed: () {}),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        child: Column(
                                          children: [
                                            Text('Anul '),
                                            Text('$years'),
                                          ],
                                        ),
                                        onPressed: () {}),
                                    ElevatedButton(
                                        child: Column(
                                          children: [
                                            Text('Runtime'),
                                            Text('$run'),
                                          ],
                                        ),
                                        onPressed: () {}),

                                  ],
                                ),ElevatedButton(
                            child: Column(
                              children: [
                                Text('Incarcare pe platforma',maxLines: 2,),
                                Text(datee),
                              ],
                            ),
                            onPressed: () {}),
                              ],

                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
