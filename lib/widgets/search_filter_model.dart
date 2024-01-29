import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class SearchFilterModal extends StatelessWidget {
  SearchFilterModal({super.key, required this.widget});

  late var widget;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // Section 1 - Header
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: AppColor.primaryExtraSoft,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      const Text('Reset', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const Text(
                'Filters',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'inter'),
              ),
              widget,
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),

        // Sort By Option
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: ListTileTheme(
            selectedColor: AppColor.primary,
            textColor: Colors.grey,
            child: const ListTile(
              selected: true,
              title:
                  Text('Newest', style: TextStyle(fontWeight: FontWeight.w600)),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ),
        ),
        // Sort By Option
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: ListTileTheme(
            selectedColor: AppColor.primary,
            textColor: Colors.grey,
            child: const ListTile(
              selected: false,
              title:
                  Text('Oldest', style: TextStyle(fontWeight: FontWeight.w600)),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ),
        ),
        // Sort By Option
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: ListTileTheme(
            selectedColor: AppColor.primary,
            textColor: Colors.grey,
            child: const ListTile(
              selected: false,
              title: Text('Popular',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
