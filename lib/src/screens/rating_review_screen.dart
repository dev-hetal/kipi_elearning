import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/rating_review_controller.dart';

class RatingReviewScreen extends GetView<RatingReviewController> {
  const RatingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ratings & Reviews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.navigateToWriteReview,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reviewList.isEmpty) {
          return const Center(child: Text('No reviews yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reviewList.length,
          itemBuilder: (context, index) {
            final review = controller.reviewList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.review,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '– ${review.name},',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' ${review.role}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) {
                        if (i < review.rating) {
                          return const Icon(Icons.star, color: Colors.amber, size: 20);
                        } else {
                          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
                        }
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
