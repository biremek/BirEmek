import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'pages/job_listings_page.dart';
import 'utils/colors.dart';
import 'pages/worker_listings_page.dart';
import 'pages/messages_page.dart';
import 'models/chat_room.dart';
import 'models/course.dart';
import 'pages/course_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/user_profile_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // 1.5 saniye bekle (daha kısa)
  await Future.delayed(const Duration(milliseconds: 1500));
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen'i kaldır
    FlutterNativeSplash.remove();
    
    return MaterialApp(
      title: 'Biremek',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _buildDarkTheme() : _buildLightTheme(),
      home: HomePage(onToggleDarkMode: toggleDarkMode),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      cardColor: AppColors.cardBackground,
      dividerColor: AppColors.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.iconPrimary),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: IconThemeData(color: AppColors.iconPrimary),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.shadowColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF2C2C2C),
      dividerColor: const Color(0xFF404040),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      cardTheme: const CardTheme(
        color: Color(0xFF2C2C2C),
        elevation: 2,
        shadowColor: Color(0x40000000),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Color(0xFFB3B3B3),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback? onToggleDarkMode;
  
  const HomePage({super.key, this.onToggleDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _notificationCount = 5; // Bildirim sayısı
  String? _selectedCategory; // Seçili kategori
  
  // Kullanıcı durumu
  bool _isLoggedIn = false;
  Map<String, String>? _userData; // Kullanıcı bilgileri
  
  // Eğitim verileri
  final List<Map<String, dynamic>> _featuredCourses = [
    {
      'title': 'Zeytin Hasadı',
      'description': 'Temel zeytin hasadı teknikleri ve modern ekipman kullanımı',
      'rating': '4.8',
      'duration': '2 Saat',
      'color': AppColors.green,
      'category': 'Tarım',
    },
    {
      'title': 'İş Güvenliği',
      'description': 'Tarım ve inşaat sektöründe iş güvenliği esasları',
      'rating': '4.9',
      'duration': '3 Saat',
      'color': AppColors.orange,
      'category': 'İnşaat',
    },
    {
      'title': 'Modern Tarım',
      'description': 'Sürdürülebilir tarım teknikleri ve teknoloji kullanımı',
      'rating': '4.7',
      'duration': '4 Saat',
      'color': AppColors.primaryBlue,
      'category': 'Tarım',
    },
    {
      'title': 'Beton Dökümü',
      'description': 'Profesyonel beton döküm teknikleri ve kalite kontrolü',
      'rating': '4.6',
      'duration': '2.5 Saat',
      'color': AppColors.orange,
      'category': 'İnşaat',
    },
    {
      'title': 'Temizlik Hizmetleri',
      'description': 'Profesyonel temizlik teknikleri ve malzeme kullanımı',
      'rating': '4.5',
      'duration': '1.5 Saat',
      'color': AppColors.pink,
      'category': 'Hizmet',
    },
    {
      'title': 'Fabrika Güvenliği',
      'description': 'Sanayi tesislerinde güvenlik protokolleri ve uygulamaları',
      'rating': '4.8',
      'duration': '3.5 Saat',
      'color': AppColors.primaryBlue,
      'category': 'Sanayi',
    },
  ];
  
  final List<Map<String, dynamic>> _newCourses = [
    {
      'title': 'İş Makinesi Kullanımı',
      'description': 'Temel iş makinesi kullanım teknikleri',
      'duration': '1.5 Saat',
      'icon': Icons.construction_rounded,
      'color': AppColors.orange,
      'category': 'İnşaat',
    },
    {
      'title': 'Seracılık',
      'description': 'Modern sera teknikleri ve bakım',
      'duration': '2.5 Saat',
      'icon': Icons.eco_rounded,
      'color': AppColors.green,
      'category': 'Tarım',
    },
    {
      'title': 'Hasta Bakımı',
      'description': 'Temel hasta bakım teknikleri',
      'duration': '3 Saat',
      'icon': Icons.medical_services_rounded,
      'color': AppColors.pink,
      'category': 'Hizmet',
    },
    {
      'title': 'Makine Bakımı',
      'description': 'Endüstriyel makine bakım ve onarım teknikleri',
      'duration': '4 Saat',
      'icon': Icons.build_rounded,
      'color': AppColors.primaryBlue,
      'category': 'Sanayi',
    },
  ];
  
  // Mesaj verileri - MessagesPage ile paylaşılacak
  final List<ChatRoom> _chatRooms = [
    ChatRoom(
      id: '1',
      otherUserId: '1',
      otherUserName: 'Ahmet Yılmaz',
      otherUserImageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
      lastMessage: 'Merhaba, iş teklifinizi aldım. Detayları konuşabilir miyiz?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      unreadCount: 2,
      isOnline: true,
    ),
    ChatRoom(
      id: '2',
      otherUserId: '2',
      otherUserName: 'Ayşe Kaya',
      otherUserImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      lastMessage: 'Zeytin hasadı işi için ne zaman başlayabiliriz?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isOnline: false,
    ),
    ChatRoom(
      id: '3',
      otherUserId: '3',
      otherUserName: 'Mehmet Demir',
      otherUserImageUrl: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
      lastMessage: 'Teşekkürler, yarın görüşürüz.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 0,
      isOnline: true,
    ),
    ChatRoom(
      id: '4',
      otherUserId: '4',
      otherUserName: 'Fatma Özkan',
      otherUserImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
      lastMessage: 'İş tamamlandı, ödeme ne zaman yapılacak?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      isOnline: false,
    ),
    ChatRoom(
      id: '5',
      otherUserId: '5',
      otherUserName: 'Ali Veli',
      otherUserImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      lastMessage: 'Yeni iş ilanınızı gördüm, başvurabilir miyim?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      isOnline: true,
    ),
  ];

  // Bildirim verileri
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Yeni İş İlanı',
      'message': 'Antalya\'da zeytin hasadı için işçi aranıyor',
      'time': '2 saat önce',
      'icon': Icons.work,
      'color': AppColors.primaryBlue,
      'type': 'job',
      'jobId': 1,
    },
    {
      'id': 2,
      'title': 'Eğitim Hatırlatması',
      'message': 'Zeytin budama eğitiminiz yarın başlıyor',
      'time': '1 gün önce',
      'icon': Icons.school,
      'color': AppColors.green,
      'type': 'education',
      'courseId': 1,
    },
    {
      'id': 3,
      'title': 'Mesaj',
      'message': 'Ahmet Yılmaz size mesaj gönderdi',
      'time': '3 gün önce',
      'icon': Icons.message,
      'color': AppColors.orange,
      'type': 'message',
      'userId': 1,
    },
    {
      'id': 4,
      'title': 'Sistem Bildirimi',
      'message': 'Profiliniz başarıyla güncellendi',
      'time': '1 hafta önce',
      'icon': Icons.info,
      'color': AppColors.textSecondary,
      'type': 'system',
    },
    {
      'id': 5,
      'title': 'Yeni İş İlanı',
      'message': 'İzmir\'de çay toplama işi. Haftalık ücret 2000 TL',
      'time': '1 hafta önce',
      'icon': Icons.work,
      'color': AppColors.primaryBlue,
      'type': 'job',
      'jobId': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  // Sayfaları dinamik olarak oluşturan method
  List<Widget> get _pages {
    print('_pages getter called - _isLoggedIn: $_isLoggedIn, _userData: $_userData');
    return [
      const JobListingsPage(),
      const SizedBox(), // Placeholder - will be replaced in build method
      const WorkerListingsPage(),
      _isLoggedIn && _userData != null
          ? UserProfilePage(
              role: _userData!['role'] ?? '',
              name: _userData!['name'] ?? '',
              email: _userData!['email'] ?? '',
              phone: _userData!['phone'] ?? '',
              address: _userData!['address'] ?? '',
              onLogout: _onUserLogout,
              onToggleDarkMode: widget.onToggleDarkMode,
            )
          : ProfilePage(onUserRegistered: _onUserLogin),
    ];
  }

  // Kullanıcı giriş yaptığında çağrılacak method
  void _onUserLogin(Map<String, String> userData) {
    print('_onUserLogin called with data: $userData');
    setState(() {
      _isLoggedIn = true;
      _userData = userData;
      _selectedIndex = 3; // Profil sekmesini seç
    });
    print('_isLoggedIn: $_isLoggedIn, _userData: $_userData, _selectedIndex: $_selectedIndex');
  }

  // Kullanıcı çıkış yaptığında çağrılacak method
  void _onUserLogout() {
    setState(() {
      _isLoggedIn = false;
      _userData = null;
    });
  }

  Widget _buildEducationContent() {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildEducationHeader(),
              _buildFeaturedCourses(),
              _buildPopularCategories(),
              _buildNewCourses(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Merhaba 👋',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text(
                      'Bugün ne öğrenmek\nistersiniz?',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.iconSecondary,
                  size: isSmallScreen ? 18 : 20,
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Eğitim ara',
                      hintStyle: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCategory == null 
                  ? 'Öne Çıkan Eğitimler'
                  : '$_selectedCategory Eğitimleri',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: _filteredFeaturedCourses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bu kategoride eğitim bulunamadı',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: _filteredFeaturedCourses.map((course) => 
                    _buildFeaturedCourseCard(
                      course['title'],
                      course['description'],
                      course['rating'],
                      course['duration'],
                      course['color'],
                    ),
                  ).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCourseCard(
    String title,
    String description,
    String rating,
    String duration,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        // Örnek Course objesi oluştur
        final course = Course(
          id: '1',
          title: title,
          description: description,
          instructorName: 'Uzman Eğitmen',
          instructorImage: 'https://example.com/instructor.jpg',
          duration: duration,
          level: 'Başlangıç',
          thumbnail: 'https://example.com/thumbnail.jpg',
          isFree: true,
          rating: double.parse(rating),
          studentCount: 150,
          lessonCount: 5,
          topics: [
            'Temel Bilgiler',
            'Pratik Uygulamalar',
            'Değerlendirme',
          ],
          price: 0.0,
          createdAt: DateTime.now(),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 280,
        height: 260,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 40,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildPopularCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popüler Kategoriler',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildCategoryCard('Tarım', Icons.eco_rounded, AppColors.green),
              _buildCategoryCard('İnşaat', Icons.construction_rounded, AppColors.orange),
              _buildCategoryCard('Hizmet', Icons.cleaning_services_rounded, AppColors.pink),
              _buildCategoryCard('Sanayi', Icons.factory_rounded, AppColors.primaryBlue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    final isSelected = _selectedCategory == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? null : title;
        });
        
        // Kategori seçimi hakkında bilgi göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSelected 
                ? 'Tüm kategoriler gösteriliyor'
                : '$title kategorisi eğitimleri gösteriliyor',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: isSelected ? Colors.grey : color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 120,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected 
            ? color.withValues(alpha: 0.2)
            : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
            ? Border.all(color: color, width: 2)
            : null,
          boxShadow: isSelected 
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: isSelected ? 32 : 28,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: isSelected ? 13 : 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Seçili',
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCategory == null 
                  ? 'Yeni Eğitimler'
                  : '$_selectedCategory Eğitimleri',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        _filteredNewCourses.isEmpty
            ? Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bu kategoride eğitim bulunamadı',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _filteredNewCourses.map((course) => 
                  _buildNewCourseCard(
                    course['title'],
                    course['description'],
                    course['duration'],
                    course['icon'],
                    course['color'],
                  ),
                ).toList(),
              ),
      ],
    );
  }

  Widget _buildNewCourseCard(
    String title,
    String description,
    String duration,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        // Örnek Course objesi oluştur
        final course = Course(
          id: '2',
          title: title,
          description: description,
          instructorName: 'Uzman Eğitmen',
          instructorImage: 'https://example.com/instructor.jpg',
          duration: duration,
          level: 'Orta',
          thumbnail: 'https://example.com/thumbnail.jpg',
          isFree: true,
          rating: 4.5,
          studentCount: 200,
          lessonCount: 8,
          topics: [
            'Temel Bilgiler',
            'Pratik Uygulamalar',
            'Değerlendirme',
          ],
          price: 0.0,
          createdAt: DateTime.now(),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              duration,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                iconSize: 24,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagesPage(
                        chatRooms: _chatRooms,
                        onChatRoomsUpdated: (updatedChatRooms) {
                          setState(() {});
                        },
                      ),
                    ),
                  ).then((_) {
                    // Mesajlar sayfasından döndüğünde bildirim sayısını güncelle
                    setState(() {});
                  });
                },
              ),
              if (_getUnreadMessageCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _getUnreadMessageCount() > 9 ? '9+' : _getUnreadMessageCount().toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        title: Container(
          height: 240,
          width: isSmallScreen ? screenWidth * 1.6 : 1000,
          margin: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/images/Logotype.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: false,
        actions: [
          // Bildirimler butonu
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none, 
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                iconSize: 24,
                onPressed: () {
                  _showNotificationsDialog(context);
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _notificationCount > 9 ? '9+' : _notificationCount.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedIndex == 1 ? _buildEducationContent() : _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? const Color(0xFF404040) : AppColors.cardBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? const Color(0x40000000) : AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.work_rounded, isSmallScreen ? 'İşler' : 'İş İlanları', 0),
              _buildNavItem(Icons.school_rounded, isSmallScreen ? 'Eğitim' : 'Eğitimler', 1),
              _buildNavItem(Icons.people_rounded, isSmallScreen ? 'İşçiler' : 'İşçi İlanları', 2),
              _buildNavItem(Icons.person_rounded, 'Profil', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppColors.primaryBlue 
                  : (isDarkMode ? const Color(0xFFB3B3B3) : AppColors.textSecondary),
              size: isSmallScreen ? 20 : 22,
            ),
            SizedBox(height: isSmallScreen ? 2 : 3),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 10 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected 
                    ? AppColors.primaryBlue 
                    : (isDarkMode ? const Color(0xFFB3B3B3) : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bildirimler',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return Column(
                        children: [
                          _buildNotificationItem(
                            notification['title'],
                            notification['message'],
                            notification['time'],
                            notification['icon'],
                            notification['color'],
                            notification,
                          ),
                          if (index < _notifications.length - 1) const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _notificationCount = 0;
                        _notifications.clear(); // Tüm bildirimleri temizle
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tüm bildirimler temizlendi'),
                          backgroundColor: AppColors.primaryBlue,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Tümünü Temizle',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, IconData icon, Color iconColor, Map<String, dynamic> notification) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Dialog'u kapat
        _handleNotificationTap(notification);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Okunmamış mesaj sayısını hesapla
  int _getUnreadMessageCount() {
    return _chatRooms.fold(0, (total, chatRoom) => total + chatRoom.unreadCount);
  }
  
  // Filtrelenmiş eğitim listelerini döndür
  List<Map<String, dynamic>> get _filteredFeaturedCourses {
    if (_selectedCategory == null) {
      return _featuredCourses;
    }
    return _featuredCourses.where((course) => course['category'] == _selectedCategory).toList();
  }
  
  List<Map<String, dynamic>> get _filteredNewCourses {
    if (_selectedCategory == null) {
      return _newCourses;
    }
    return _newCourses.where((course) => course['category'] == _selectedCategory).toList();
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];
    
    // Bildirimi listeden kaldır
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notification['id']);
      if (_notificationCount > 0) {
        _notificationCount--;
      }
    });
    
    switch (type) {
      case 'job':
        // İş ilanları sayfasına git
        setState(() {
          _selectedIndex = 0; // İş ilanları sekmesi
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İş ilanları sayfasına yönlendiriliyorsunuz...'),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
        break;
      case 'education':
        // Eğitim sayfasına git
        setState(() {
          _selectedIndex = 1; // Eğitim sekmesi
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eğitim sayfasına yönlendiriliyorsunuz...'),
            backgroundColor: AppColors.green,
          ),
        );
        break;
      case 'message':
        // Mesaj sayfasına git
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesPage(
              chatRooms: _chatRooms,
              onChatRoomsUpdated: (updatedChatRooms) {
                setState(() {});
              },
            ),
          ),
        ).then((_) {
          setState(() {});
        });
        break;
      case 'system':
        // Sistem bildirimi - sadece mesaj göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notification['message']),
            backgroundColor: AppColors.textSecondary,
          ),
        );
        break;
    }
  }
}



