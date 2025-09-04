import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biremek/models/course.dart';
import 'package:biremek/utils/colors.dart';
import 'package:biremek/pages/course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tümü';
  String _selectedLevel = 'Tümü';
  bool _onlyFree = false;

  @override
  void initState() {
    super.initState();
    _allCourses = _generateSampleCourses();
    _filteredCourses = List.from(_allCourses);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _filterCourses();
  }

  void _filterCourses() {
    setState(() {
      final searchText = _searchController.text.toLowerCase();
      
      _filteredCourses = _allCourses.where((course) {
        // Arama metni kontrolü
        final matchesSearch = course.title.toLowerCase().contains(searchText) ||
            course.description.toLowerCase().contains(searchText) ||
            course.instructorName.toLowerCase().contains(searchText) ||
            course.topics.any((topic) => topic.toLowerCase().contains(searchText));

        // Kategori kontrolü
        final matchesCategory = _selectedCategory == 'Tümü' || 
            course.topics.any((topic) => topic == _selectedCategory);

        // Seviye kontrolü
        final matchesLevel = _selectedLevel == 'Tümü' || 
            course.level == _selectedLevel;

        // Ücretsiz kontrolü
        final matchesPrice = !_onlyFree || course.isFree;

        return matchesSearch && matchesCategory && matchesLevel && matchesPrice;
      }).toList();
    });
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(course: course),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    course.thumbnail,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (course.isFree)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Ücretsiz',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(course.instructorImage),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        course.instructorName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.studentCount} öğrenci',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.lessonCount} ders',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: course.topics.map((topic) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          topic,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.isFree ? 'Ücretsiz' : '${course.price} ₺',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to course detail page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Detaylar',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 55,
        title: Container(
          height: 100,
          width: 400,
          margin: EdgeInsets.only(left: 40),
          child: Image.asset(
            'assets/images/Logotype.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  maxChildSize: 0.9,
                  minChildSize: 0.5,
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Filtreler',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Kategori',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                'Tümü',
                                'Sera Yetiştiriciliği',
                                'Tarla Tarımı',
                                'Bağcılık',
                                'Hayvancılık',
                                'Organik Tarım',
                              ].map((category) {
                                final isSelected = _selectedCategory == category;
                                return FilterChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                    _filterCourses();
                                  },
                                  backgroundColor: Colors.grey[100],
                                  selectedColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                                  checkmarkColor: AppColors.primaryBlue,
                                  labelStyle: GoogleFonts.poppins(
                                    color: isSelected ? AppColors.primaryBlue : Colors.grey[800],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seviye',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                'Tümü',
                                'Başlangıç',
                                'Orta',
                                'İleri',
                              ].map((level) {
                                final isSelected = _selectedLevel == level;
                                return FilterChip(
                                  label: Text(level),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedLevel = level;
                                    });
                                    _filterCourses();
                                  },
                                  backgroundColor: Colors.grey[100],
                                  selectedColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                                  checkmarkColor: AppColors.primaryBlue,
                                  labelStyle: GoogleFonts.poppins(
                                    color: isSelected ? AppColors.primaryBlue : Colors.grey[800],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _onlyFree,
                                  onChanged: (value) {
                                    setState(() {
                                      _onlyFree = value ?? false;
                                    });
                                    _filterCourses();
                                  },
                                ),
                                Text(
                                  'Sadece ücretsiz eğitimler',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                                child: Text(
                                  'Filtreleri Uygula',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Eğitim ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                return _buildCourseCard(_filteredCourses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Course> _generateSampleCourses() {
    return [
      Course(
        id: '1',
        title: 'Modern Sera Yönetimi',
        description: 'Modern sera sistemlerinde verimli üretim teknikleri ve yönetim stratejileri.',
        instructorName: 'Prof. Dr. Ahmet Yılmaz',
        instructorImage: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
        thumbnail: 'https://images.unsplash.com/photo-1560493676-04071c5f467b',
        rating: 4.8,
        studentCount: 245,
        lessonCount: 12,
        duration: '8 saat',
        level: 'Orta',
        topics: ['Sera Yönetimi', 'Bitki Bakımı', 'İklimlendirme'],
        price: 199.99,
        isFree: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Course(
        id: '2',
        title: 'Organik Tarım Temelleri',
        description: 'Organik tarım prensipleri ve uygulamaları hakkında kapsamlı bir eğitim.',
        instructorName: 'Dr. Ayşe Kaya',
        instructorImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
        thumbnail: 'https://images.unsplash.com/photo-1495107334309-fcf20504a5ab',
        rating: 4.6,
        studentCount: 189,
        lessonCount: 10,
        duration: '6 saat',
        level: 'Başlangıç',
        topics: ['Organik Tarım', 'Toprak Yönetimi', 'Pest Kontrolü'],
        price: 0,
        isFree: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Course(
        id: '3',
        title: 'Bağcılık ve Şarap Üretimi',
        description: 'Profesyonel bağcılık teknikleri ve şarap üretim süreçleri.',
        instructorName: 'Prof. Dr. Mustafa Şahin',
        instructorImage: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
        thumbnail: 'https://images.unsplash.com/photo-1601448166762-31fe6e842df2',
        rating: 4.9,
        studentCount: 156,
        lessonCount: 15,
        duration: '10 saat',
        level: 'İleri',
        topics: ['Bağcılık', 'Şarap Üretimi', 'Kalite Kontrolü'],
        price: 299.99,
        isFree: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
} 