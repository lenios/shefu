import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final Widget image;
  const FullScreenImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        // Image Wrapper
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // Image Widget
          child: image,
        ),
      ),
    );
  }
}
