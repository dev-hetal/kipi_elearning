import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/write_review_controller.dart';

class WriteReviewScreen extends GetView<WriteReviewController> {
  const WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating stars
            Obx(() {
              return Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < controller.rating.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => controller.setRating(index + 1),
                  );
                }),
              );
            }),
            const SizedBox(height: 24),

            // Review text field
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
              onChanged: controller.setReviewText,
            ),
            const SizedBox(height: 16),

            // Error message
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 16),

            // Submit button
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitReview,
                  child: controller.isSubmitting.value
                      ? const CircularProgressIndicator()
                      : const Text('Submit Review'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
