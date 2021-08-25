import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayRecipe extends StatelessWidget {
  const DisplayRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(child: Text('back'.tr), onPressed: () => Get.back()),
          Text('detail'),
        ],
      ),
    );
  }
}
