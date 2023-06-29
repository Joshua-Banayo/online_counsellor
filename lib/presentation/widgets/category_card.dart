import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.category});
  final Map<String, dynamic> category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedCategory = ref.watch(selectedCategoryProvider);
    var isSelected = selectedCategory == category['name']!;
    var height = isSelected ? 170.0 : 150.0;
    var color = isSelected ? secondaryColor.withOpacity(.1) : Colors.white;
    var elevation = isSelected ? 5.0 : 0.0;
    var fontSize = isSelected ? 17.0 : 14.0;
    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = category['name']!;
      },
      child: Card(
        elevation: elevation,
        child: Container(
          padding: const EdgeInsets.all(8),
          // width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset(
                category['icon']!,
                height: 80,
              ),
              Text(
                category['name']!,
                textAlign: TextAlign.center,
                style: normalText(
                    color: primaryColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
