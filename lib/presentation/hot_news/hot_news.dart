import 'package:flutter/material.dart';

class NetflixHotNewsScreen extends StatefulWidget {
  const NetflixHotNewsScreen({super.key});

  @override
  State<NetflixHotNewsScreen> createState() => _NetflixHotNewsScreenState();
}

class _NetflixHotNewsScreenState extends State<NetflixHotNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Hot News')));
  }
}
