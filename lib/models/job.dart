import 'package:flutter/material.dart';

class Job {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final String companyName;
  final String companyLogo;
  final String employerName;
  final double dailyWage;
  final String postedAt;
  final List<JobReview> reviews;
  final String jobType;
  final String duration;
  final List<String> requirements;
  final List<String> benefits;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.companyName,
    required this.companyLogo,
    required this.employerName,
    required this.dailyWage,
    required this.postedAt,
    required this.reviews,
    required this.jobType,
    required this.duration,
    required this.requirements,
    required this.benefits,
  });

  // Ortalama puanı hesapla
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    double totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  // Toplam yorum sayısı
  int get reviewCount => reviews.length;
}

class JobReview {
  final String id;
  final String userName;
  final String userImage;
  final String comment;
  final double rating;
  final String date;
  final bool isVerifiedWorker; // Bu işte gerçekten çalışmış mı

  JobReview({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.rating,
    required this.date,
    this.isVerifiedWorker = false,
  });
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

// Örnek iş ilanları
final List<Job> sampleJobs = [
  Job(
    id: '1',
    title: 'Zeytin toplama ve yazgı yazma için eleman aranıyor',
    description: 'Zeytin toplama ve yazgı yazma işlerinde çalışacak deneyimli personel aranmaktadır.',
    location: 'Muğla/Milas',
    category: 'Zeytin',
    companyName: 'Sevgül Zeytincilik',
    companyLogo: 'https://images.unsplash.com/photo-1601448166762-31fe6e842df2',
    employerName: 'Emir Sevgül',
    dailyWage: 450.0,
    postedAt: '2 gün önce',
    reviews: [
      JobReview(
        id: '1',
        userName: 'Ahmet Yılmaz',
        userImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        comment: 'Çok güzel bir iş ortamı. İşveren çok anlayışlı ve ücretler zamanında ödeniyor. Kesinlikle tavsiye ederim.',
        rating: 4.5,
        date: '1 hafta önce',
        isVerifiedWorker: true,
      ),
      JobReview(
        id: '2',
        userName: 'Fatma Demir',
        userImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        comment: 'İş yoğun ama ücretler iyi. Yemek ve konaklama sağlanıyor.',
        rating: 4.0,
        date: '2 hafta önce',
        isVerifiedWorker: true,
      ),
    ],
    jobType: 'Tam Zamanlı',
    duration: '2 gün',
    requirements: ['Zeytin Toplama', 'Yazgı Yazma', 'Bahçe İşleri'],
    benefits: ['Yemek', 'Konaklama'],
  ),
  Job(
    id: '2',
    title: 'İnşaat malzemesi taşıma ve yardımı için eleman aranıyor',
    description: 'İnşaat malzemesi taşıma ve yardımı işlerinde çalışacak güçlü ve dayanıklı personel aranmaktadır.',
    location: 'Konya/Selçuklu',
    category: 'İnşaat',
    companyName: 'Taniş İnşaat',
    companyLogo: 'https://images.unsplash.com/photo-1560493676-04071c5f467b',
    employerName: 'Nurullah Taniş',
    dailyWage: 500.0,
    postedAt: '15 gün önce',
    reviews: [
      JobReview(
        id: '3',
        userName: 'Mehmet Kaya',
        userImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        comment: 'Fiziksel olarak zorlu bir iş ama ücretler çok iyi. İşveren güvenilir.',
        rating: 4.2,
        date: '3 gün önce',
        isVerifiedWorker: true,
      ),
    ],
    jobType: 'Tam Zamanlı',
    duration: '15 gün',
    requirements: ['İnşaat İşleri', 'Malzeme Taşıma', 'Fiziksel Güç'],
    benefits: ['Yemek', 'Sigorta'],
  ),
  Job(
    id: '3',
    title: 'Cafe içerisinde bulaşık yıkama için eleman aranıyor',
    description: 'Cafe içerisinde bulaşık yıkama işlerinde çalışacak titiz ve düzenli personel aranmaktadır.',
    location: 'Mersin/Pozcu',
    category: 'Cafe',
    companyName: 'Bulan Cafe',
    companyLogo: 'https://images.unsplash.com/photo-1495107334309-fcf20504a5ab',
    employerName: 'Oğuz Bulan',
    dailyWage: 400.0,
    postedAt: 'Bugün',
    reviews: [],
    jobType: 'Tam Zamanlı',
    duration: 'Bugün',
    requirements: ['Bulaşık Yıkama', 'Temizlik', 'Düzen'],
    benefits: ['Yemek'],
  ),
  Job(
    id: '4',
    title: 'Ev temizliği için eleman aranıyor',
    description: '3+1 ev temizliği işlerinde çalışacak deneyimli ve titiz personel aranmaktadır.',
    location: 'İstanbul/Beykoz',
    category: 'Ev Temizliği',
    companyName: 'Çümen Temizlik',
    companyLogo: 'https://images.unsplash.com/photo-1601448166762-31fe6e842df2',
    employerName: 'Emine Çümen',
    dailyWage: 350.0,
    postedAt: '7 gün önce',
    reviews: [
      JobReview(
        id: '4',
        userName: 'Ayşe Özkan',
        userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        comment: 'Çok temiz ve düzenli bir iş ortamı. İşveren çok nazik.',
        rating: 4.8,
        date: '5 gün önce',
        isVerifiedWorker: true,
      ),
    ],
    jobType: 'Tam Zamanlı',
    duration: '7 gün',
    requirements: ['Ev Temizliği', 'Titizlik', 'Düzen'],
    benefits: ['Yemek', 'Yol'],
  ),
  Job(
    id: '5',
    title: 'Çay fabrikasında çalışacak eleman aranıyor',
    description: 'Çay fabrikasında çalışacak vardiyalı personel aranmaktadır.',
    location: 'Trabzon/Sürmene',
    category: 'Çay',
    companyName: 'Yılmaz Çay',
    companyLogo: 'https://images.unsplash.com/photo-1495107334309-fcf20504a5ab',
    employerName: 'Mehmet Yılmaz',
    dailyWage: 450.0,
    postedAt: 'dün',
    reviews: [
      JobReview(
        id: '5',
        userName: 'Ali Veli',
        userImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        comment: 'Vardiyalı çalışma zor ama ücretler iyi. Servis ve yemek var.',
        rating: 3.8,
        date: '1 gün önce',
        isVerifiedWorker: true,
      ),
    ],
    jobType: 'Vardiyalı',
    duration: 'Sürekli',
    requirements: ['Fabrika İşçiliği', 'Vardiyalı Çalışma', 'Üretim'],
    benefits: ['Yemek', 'Servis', 'Sigorta'],
  ),
]; 