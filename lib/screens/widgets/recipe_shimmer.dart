import 'package:flutter/material.dart';
import 'package:recipe_app/consts/sizes.dart';
import 'package:recipe_app/screens/widgets/shimmer_widget.dart';

class RecipeShimmer extends StatelessWidget {
  const RecipeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      height: AppSizes.getResponsiveSize(30),
      width: AppSizes.getResponsiveSize(21.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        gradient: LinearGradient(
          colors: [Colors.grey.withOpacity(0.05), Colors.white],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: ShimmerContainer(20, 10),
          ),
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [ShimmerContainer(8, 2), ShimmerContainer(8, 2)],
              ))
        ],
      ),
    );
  }
}
