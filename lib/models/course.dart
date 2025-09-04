class Course {
  final String id;
  final String title;
  final String description;
  final String instructorName;
  final String instructorImage;
  final String thumbnail;
  final double rating;
  final int studentCount;
  final int lessonCount;
  final String duration;
  final String level;
  final List<String> topics;
  final double price;
  final bool isFree;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.instructorImage,
    required this.thumbnail,
    required this.rating,
    required this.studentCount,
    required this.lessonCount,
    required this.duration,
    required this.level,
    required this.topics,
    required this.price,
    required this.isFree,
    required this.createdAt,
  });
} 