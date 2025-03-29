import 'package:flutter/material.dart';
import 'package:foodies/widgets/custom_appbar.dart';

final List<String> categories = [
  "All",
  "Burgers",
  "Pizza",
  "Asian",
  "Desserts",
  "Kottu",
  "Fried Rice",
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Foodies',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search..",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 244, 219),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: selectedCategoryIndex == index,
                      onSelected: (selected) {
                        setState(
                          () {
                            selectedCategoryIndex = index;
                          },
                        );
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: selectedCategoryIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      checkmarkColor: Colors.white,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
