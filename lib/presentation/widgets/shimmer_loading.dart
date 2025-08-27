import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: ShimmerBox(width: 150, height: 24),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: const Column(
                        children: [
                          ShimmerBox(width: double.infinity, height: 200),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                ShimmerBox(width: double.infinity, height: 16),
                                SizedBox(height: 4),
                                ShimmerBox(width: 80, height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.all(16),
              child: ShimmerBox(width: 150, height: 24),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: const Column(
                        children: [
                          ShimmerBox(width: double.infinity, height: 200),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                ShimmerBox(width: double.infinity, height: 16),
                                SizedBox(height: 4),
                                ShimmerBox(width: 80, height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({required this.width, required this.height, super.key});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
