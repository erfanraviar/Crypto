// ignore_for_file: sort_child_properties_last, must_be_immutable

import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  PageController controller;
  BottomNav({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4,
      color: primaryColor,
      child: SizedBox(
        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        controller.animateToPage(0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.home)),
                  IconButton(
                      onPressed: () {
                        controller.animateToPage(1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.bar_chart))
                ],
              ),
              width: MediaQuery.of(context).size.width / 2 - 20,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        controller.animateToPage(2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.person)),
                  IconButton(
                      onPressed: () {
                        controller.animateToPage(3,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.bookmark))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
