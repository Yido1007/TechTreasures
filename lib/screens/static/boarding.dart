// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../../core/storage.dart';
import '../../widgets/boardingitem.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  // Boarding Screen image, title and description
  final boardingData = [
    {
      "image": "assets/images/boarding1.jpg",
      "title": "Choose Product.",
      "description": "Wer have a 1k+ Product. Choose Your product from our E-commerce shop.",
    },
    {
      "image": "assets/images/boarding2.jpg",
      "title": "Easy & Safe Payment",
      "description":
          "Easy checkout & Safe payment method. Trusted by our Customers from all over the world",
    },
    {
      "image": "assets/images/boarding3.jpg",
      "title": "Fast Delivery",
      "description": "Reliable and fast delivery. We Deliver your product the fastest way possible",
    }
  ];

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            // Top skip button
            child: InkWell(
              onTap: () async {
                final storage = Storage();
                await storage.firstLauched();
                GoRouter.of(context).replace("/home");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: page == boardingData.length ? const Text("finish") : const Text("skip"),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PreloadPageView.builder(
          itemCount: boardingData.length,
          preloadPagesCount: boardingData.length,
          onPageChanged: (value) {
            setState(() {
              page = value;
            });
          },
          itemBuilder: (context, index) => BoardingItem(
            // BoardingItem
              image: boardingData[index]["image"]!,
              title: boardingData[index]["title"]!,
              description: boardingData[index]["description"]!),
        ),
      ),
      bottomNavigationBar: SizedBox(
        // 3 Dot 
        height: 70,
        child: Align(
          alignment: Alignment.center,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: boardingData.length,
            itemBuilder: (context, index) => Icon(
              page == index ? Icons.circle_outlined : Icons.circle,
            ),
          ),
        ),
      ),
    );
  }
}
