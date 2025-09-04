import 'package:biremek/models/review.dart';

class Worker {
  final String id;
  final String name;
  final int age;
  final String location;
  final String experience;
  final List<String> skills;
  final String description;
  final double expectedSalary;
  final String availability; // Tam zamanlı, Yarı zamanlı, Geçici
  final DateTime postedDate;
  final String contactInfo;
  final double hourlyRate;
  final bool isAvailable;
  final String profileImage;
  final double rating;
  final int completedJobs;
  final List<Review> reviews;
  final DateTime createdAt;

  Worker({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.experience,
    required this.skills,
    required this.description,
    required this.expectedSalary,
    required this.availability,
    required this.postedDate,
    required this.contactInfo,
    required this.hourlyRate,
    required this.isAvailable,
    required this.profileImage,
    this.rating = 0.0,
    this.completedJobs = 0,
    this.reviews = const [],
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();
}

// Örnek işçi ilanları
final List<Worker> sampleWorkers = [
  Worker(
    id: '1',
    name: 'Ahmet Yılmaz',
    age: 35,
    location: 'Konya',
    experience: '10 yıl',
    skills: [
      'Tarla işleri',
      'Traktör kullanımı',
      'Sulama sistemleri',
      'İlaçlama'
    ],
    description: '10 yıllık deneyimli tarla işçisiyim. Traktör kullanımı ve tüm tarım işlerinde tecrübeliyim.',
    expectedSalary: 5500,
    availability: 'Tam zamanlı',
    postedDate: DateTime.now().subtract(const Duration(days: 3)),
    contactInfo: '0555 111 2233',
    hourlyRate: 75.0,
    isAvailable: true,
    profileImage: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
    rating: 4.8,
    completedJobs: 127,
  ),
  Worker(
    id: '2',
    name: 'Ayşe Demir',
    age: 28,
    location: 'Antalya',
    experience: '5 yıl',
    skills: [
      'Sera işleri',
      'Bitki bakımı',
      'Organik tarım',
      'Hasat'
    ],
    description: '5 yıllık sera deneyimim var. Özellikle domates ve salatalık yetiştiriciliğinde uzmanım.',
    expectedSalary: 4800,
    availability: 'Tam zamanlı',
    postedDate: DateTime.now().subtract(const Duration(days: 1)),
    contactInfo: '0555 444 5566',
    hourlyRate: 65.0,
    isAvailable: true,
    profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
    rating: 4.5,
    completedJobs: 84,
  ),
  Worker(
    id: '3',
    name: 'Mehmet Kaya',
    age: 42,
    location: 'İzmir',
    experience: '15 yıl',
    skills: [
      'Zeytin yetiştiriciliği',
      'Bağcılık',
      'Meyve bahçesi',
      'Budama'
    ],
    description: '15 yıllık deneyimli bahçe işçisiyim. Zeytin ve üzüm yetiştiriciliğinde uzmanım.',
    expectedSalary: 6000,
    availability: 'Tam zamanlı',
    postedDate: DateTime.now(),
    contactInfo: '0555 777 8899',
    hourlyRate: 85.0,
    isAvailable: false,
    profileImage: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
    rating: 4.9,
    completedJobs: 156,
  ),
]; 