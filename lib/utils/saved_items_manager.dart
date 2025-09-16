import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';
import '../models/course.dart';

class SavedItemsManager {
  static const String _savedJobsKey = 'saved_jobs';
  static const String _savedCoursesKey = 'saved_courses';
  
  static SavedItemsManager? _instance;
  static SavedItemsManager get instance {
    _instance ??= SavedItemsManager._();
    return _instance!;
  }
  
  SavedItemsManager._();

  // Kaydedilen iş ilanlarını getir
  Future<List<Job>> getSavedJobs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJobsJson = prefs.getStringList(_savedJobsKey) ?? [];
      
      return savedJobsJson.map((jobJson) {
        final jobMap = json.decode(jobJson) as Map<String, dynamic>;
        return _jobFromMap(jobMap);
      }).toList();
    } catch (e) {
      print('Kaydedilen iş ilanları yüklenirken hata: $e');
      return [];
    }
  }

  // Kaydedilen eğitimleri getir
  Future<List<Course>> getSavedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCoursesJson = prefs.getStringList(_savedCoursesKey) ?? [];
      
      return savedCoursesJson.map((courseJson) {
        final courseMap = json.decode(courseJson) as Map<String, dynamic>;
        return _courseFromMap(courseMap);
      }).toList();
    } catch (e) {
      print('Kaydedilen eğitimler yüklenirken hata: $e');
      return [];
    }
  }

  // İş ilanını kaydet
  Future<bool> saveJob(Job job) async {
    try {
      final savedJobs = await getSavedJobs();
      
      // Zaten kayıtlı mı kontrol et
      if (savedJobs.any((savedJob) => savedJob.id == job.id)) {
        return false; // Zaten kayıtlı
      }
      
      savedJobs.add(job);
      final prefs = await SharedPreferences.getInstance();
      final savedJobsJson = savedJobs.map((job) => json.encode(_jobToMap(job))).toList();
      
      return await prefs.setStringList(_savedJobsKey, savedJobsJson);
    } catch (e) {
      print('İş ilanı kaydedilirken hata: $e');
      return false;
    }
  }

  // Eğitimi kaydet
  Future<bool> saveCourse(Course course) async {
    try {
      final savedCourses = await getSavedCourses();
      
      // Zaten kayıtlı mı kontrol et
      if (savedCourses.any((savedCourse) => savedCourse.id == course.id)) {
        return false; // Zaten kayıtlı
      }
      
      savedCourses.add(course);
      final prefs = await SharedPreferences.getInstance();
      final savedCoursesJson = savedCourses.map((course) => json.encode(_courseToMap(course))).toList();
      
      return await prefs.setStringList(_savedCoursesKey, savedCoursesJson);
    } catch (e) {
      print('Eğitim kaydedilirken hata: $e');
      return false;
    }
  }

  // İş ilanını kayıtlardan kaldır
  Future<bool> removeJob(String jobId) async {
    try {
      final savedJobs = await getSavedJobs();
      savedJobs.removeWhere((job) => job.id == jobId);
      
      final prefs = await SharedPreferences.getInstance();
      final savedJobsJson = savedJobs.map((job) => json.encode(_jobToMap(job))).toList();
      
      return await prefs.setStringList(_savedJobsKey, savedJobsJson);
    } catch (e) {
      print('İş ilanı kaldırılırken hata: $e');
      return false;
    }
  }

  // Eğitimi kayıtlardan kaldır
  Future<bool> removeCourse(String courseId) async {
    try {
      final savedCourses = await getSavedCourses();
      savedCourses.removeWhere((course) => course.id == courseId);
      
      final prefs = await SharedPreferences.getInstance();
      final savedCoursesJson = savedCourses.map((course) => json.encode(_courseToMap(course))).toList();
      
      return await prefs.setStringList(_savedCoursesKey, savedCoursesJson);
    } catch (e) {
      print('Eğitim kaldırılırken hata: $e');
      return false;
    }
  }

  // İş ilanının kayıtlı olup olmadığını kontrol et
  Future<bool> isJobSaved(String jobId) async {
    try {
      final savedJobs = await getSavedJobs();
      return savedJobs.any((job) => job.id == jobId);
    } catch (e) {
      print('İş ilanı kayıt durumu kontrol edilirken hata: $e');
      return false;
    }
  }

  // Eğitimin kayıtlı olup olmadığını kontrol et
  Future<bool> isCourseSaved(String courseId) async {
    try {
      final savedCourses = await getSavedCourses();
      return savedCourses.any((course) => course.id == courseId);
    } catch (e) {
      print('Eğitim kayıt durumu kontrol edilirken hata: $e');
      return false;
    }
  }

  // Job'ı Map'e çevir
  Map<String, dynamic> _jobToMap(Job job) {
    return {
      'id': job.id,
      'title': job.title,
      'description': job.description,
      'location': job.location,
      'category': job.category,
      'companyName': job.companyName,
      'companyLogo': job.companyLogo,
      'employerName': job.employerName,
      'dailyWage': job.dailyWage,
      'postedAt': job.postedAt,
      'jobType': job.jobType,
      'duration': job.duration,
      'requirements': job.requirements,
      'benefits': job.benefits,
      'reviews': job.reviews.map((review) => {
        'id': review.id,
        'userName': review.userName,
        'userImage': review.userImage,
        'comment': review.comment,
        'rating': review.rating,
        'date': review.date,
        'isVerifiedWorker': review.isVerifiedWorker,
      }).toList(),
    };
  }

  // Map'i Job'a çevir
  Job _jobFromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      category: map['category'],
      companyName: map['companyName'],
      companyLogo: map['companyLogo'],
      employerName: map['employerName'],
      dailyWage: map['dailyWage'].toDouble(),
      postedAt: map['postedAt'],
      jobType: map['jobType'],
      duration: map['duration'],
      requirements: List<String>.from(map['requirements']),
      benefits: List<String>.from(map['benefits']),
      reviews: (map['reviews'] as List).map((reviewMap) => JobReview(
        id: reviewMap['id'],
        userName: reviewMap['userName'],
        userImage: reviewMap['userImage'],
        comment: reviewMap['comment'],
        rating: reviewMap['rating'].toDouble(),
        date: reviewMap['date'],
        isVerifiedWorker: reviewMap['isVerifiedWorker'] ?? false,
      )).toList(),
    );
  }

  // Course'u Map'e çevir
  Map<String, dynamic> _courseToMap(Course course) {
    return {
      'id': course.id,
      'title': course.title,
      'description': course.description,
      'instructorName': course.instructorName,
      'instructorImage': course.instructorImage,
      'thumbnail': course.thumbnail,
      'rating': course.rating,
      'studentCount': course.studentCount,
      'lessonCount': course.lessonCount,
      'duration': course.duration,
      'level': course.level,
      'topics': course.topics,
      'price': course.price,
      'isFree': course.isFree,
      'createdAt': course.createdAt.toIso8601String(),
    };
  }

  // Map'i Course'a çevir
  Course _courseFromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      instructorName: map['instructorName'],
      instructorImage: map['instructorImage'],
      thumbnail: map['thumbnail'],
      rating: map['rating'].toDouble(),
      studentCount: map['studentCount'],
      lessonCount: map['lessonCount'],
      duration: map['duration'],
      level: map['level'],
      topics: List<String>.from(map['topics']),
      price: map['price'].toDouble(),
      isFree: map['isFree'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
