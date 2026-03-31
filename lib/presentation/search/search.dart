import 'package:flutter/material.dart';

class NetflixSearchScreen extends StatefulWidget {
  const NetflixSearchScreen({super.key});

  @override
  State<NetflixSearchScreen> createState() => _NetflixSearchScreenState();
}

class _NetflixSearchScreenState extends State<NetflixSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Search Screen')));
  }
}
