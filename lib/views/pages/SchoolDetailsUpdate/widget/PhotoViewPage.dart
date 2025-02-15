
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class Photoviewpage extends StatelessWidget {
  final String assetLink;
  const Photoviewpage({super.key, required this.assetLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Beamer.of(context).beamToNamed('/school-details-updation'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(assetLink),
        ),
      ),
    );
  }
}