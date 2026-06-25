import "package:flutter/material.dart";
import "package:kipi_elearning/kipi_elearning.dart";

import "../models/get_all_courses_model.dart";

enum CourseCardType {
  listing,
  dashboard,
}

class CourseDetailCard extends StatelessWidget {
  final AllCoursesRecordList course;
  final CourseCardType cardType;
  final bool isEnrolled;
  final String? expiryDate;
  final VoidCallback? onTap;

  const CourseDetailCard({
    super.key,
    required this.course,
    this.cardType = CourseCardType.listing,
    this.isEnrolled = false,
    this.expiryDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: cardType == CourseCardType.listing ? const EdgeInsets.only(bottom: 16) : EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(cardType == CourseCardType.listing ? 14 : 11)),
              child: _buildThumbnail(),
            ),
            if (cardType == CourseCardType.listing)
              Padding(
                padding: const EdgeInsets.all(14),
                child: _buildCardContent(context),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildCardContent(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final imageUrl = course.courseThumbNail?.presignedUrl ?? "";
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: cardType == CourseCardType.listing ? 160 : 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: cardType == CourseCardType.listing ? 160 : 140,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image, size: 50, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: cardType == CourseCardType.listing ? 160 : 140,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }
    return Container(
      height: cardType == CourseCardType.listing ? 160 : 140,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image, size: 50, color: Colors.grey),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (cardType == CourseCardType.listing) ...<Widget>[
          Text(
            course.courseStatus ?? "",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            course.title ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ] else ...<Widget>[
          Text(
            course.title ?? "",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 4),
        Text(
          course.subTitle ?? "",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (cardType == CourseCardType.listing) const SizedBox(height: 12) else const Spacer(),
        Row(
          children: <Widget>[
            if (expiryDate != null) ...<Widget>[
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text(
                "Expires on $expiryDate",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ] else ...<Widget>[
              const Icon(Icons.monetization_on, size: 16),
              const SizedBox(width: 4),
              Text(
                course.price?.toString() ?? "",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
            const Spacer(),
            if (isEnrolled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "ENROLLED",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
