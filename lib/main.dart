import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:movflix/presentation/onboardings/onboarding_template.dart';
import 'core/app_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppStyle.darkTheme,
      home: const OnboardingTemplate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchPosts(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return CircularProgressIndicator(color: Colors.white);
            } else if (snapshots.data != null) {
              return ListView.builder(
                itemCount: snapshots.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      snapshots.data![index]['name'],
                      // style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(snapshots.data![index]['email']),
                  );
                },
              );
            }
            return Text('There is an error.');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await fetchPosts();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void fetchPopularMovies() async {
  final url = 'https://api.themoviedb.org/3/discover/movie';
  Response response = await get(
    Uri.parse(url),
    headers: {
      'accept': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZjgxYjUyNGE2MjE1MGE5NjBiYTk5MDAwNzA2ZmIwOCIsIm5iZiI6MTc3NDYzODc0My4wMiwic3ViIjoiNjljNmQ2OTdiNzMzNmU4YWZiNmQwOTQ5Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.tgr_L1Tn8FoOfG7vp8F66_ihHqCsYo8Vb4AF1lnw2vQ',
    },
  );
  print(response.body);
}

Future<void> updateUsers(String name, String username) async {}

Future<List<dynamic>?> fetchPosts() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'FlutterApp', // <-- important
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    print('Failed: ${response.statusCode}');
    return null;
  }
}
