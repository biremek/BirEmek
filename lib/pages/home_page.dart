import 'package:flutter/material.dart';
import 'package:biremek/models/job.dart';
import 'package:biremek/pages/job_listings_page.dart';
import 'package:biremek/pages/job_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biremek/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const JobListingsPage(),
    const NotificationsPage(),
    const Scaffold(body: Center(child: Text('Profil'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Ana Ekran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline, size: 24),
            label: 'İş İlanları',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 24),
            label: 'Bildirimler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 400;
    
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Bölge ve iş ara',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          // Recommended Jobs Title
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Text(
              'Önerilen işler',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Recommended Jobs Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: isSmallScreen ? 8 : 12,
                crossAxisSpacing: isSmallScreen ? 8 : 12,
                childAspectRatio: isSmallScreen ? 0.8 : 0.75,
              ),
              itemCount: sampleJobs.length,
              itemBuilder: (context, index) {
                final job = sampleJobs[index];
                return _buildJobCard(
                  context: context,
                  job: job,
                  icon: _getIconForCategory(job.category),
                  color: _getColorForCategory(job.category),
                  isSmallScreen: isSmallScreen,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required BuildContext context,
    required Job job,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailPage(job: job),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Text(
                  job.title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 4 : 6),
                Text(
                  job.location,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  job.postedAt,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 9 : 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'zeytin':
        return Icons.eco;
      case 'inşaat':
        return Icons.construction;
      case 'cafe':
        return Icons.restaurant;
      case 'ev temizliği':
        return Icons.cleaning_services;
      case 'çay':
        return Icons.factory;
      default:
        return Icons.work;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'zeytin':
        return Colors.green;
      case 'inşaat':
        return Colors.orange;
      case 'cafe':
        return Colors.blue;
      case 'ev temizliği':
        return Colors.purple;
      case 'çay':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _notificationCount = 5; // Bildirim sayısı

  // Bildirim verileri
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Yeni İş İlanı',
      'message': 'Antalya\'da zeytin hasadı için işçi aranıyor. Günlük ücret 300 TL.',
      'time': '2 saat önce',
      'icon': Icons.work,
      'color': AppColors.primaryBlue,
      'type': 'job',
      'jobId': 1,
      'isUnread': true,
    },
    {
      'id': 2,
      'title': 'Eğitim Hatırlatması',
      'message': 'Zeytin budama eğitiminiz yarın saat 10:00\'da başlıyor.',
      'time': '1 gün önce',
      'icon': Icons.school,
      'color': AppColors.green,
      'type': 'education',
      'courseId': 1,
      'isUnread': true,
    },
    {
      'id': 3,
      'title': 'Mesaj',
      'message': 'Ahmet Yılmaz size mesaj gönderdi: "Merhaba, iş teklifinizi aldım..."',
      'time': '3 gün önce',
      'icon': Icons.message,
      'color': AppColors.orange,
      'type': 'message',
      'userId': 1,
      'isUnread': false,
    },
    {
      'id': 4,
      'title': 'Sistem Bildirimi',
      'message': 'Profiliniz başarıyla güncellendi.',
      'time': '1 hafta önce',
      'icon': Icons.info,
      'color': AppColors.textSecondary,
      'type': 'system',
      'isUnread': false,
    },
    {
      'id': 5,
      'title': 'Yeni İş İlanı',
      'message': 'İzmir\'de çay toplama işi. Haftalık ücret 2000 TL.',
      'time': '1 hafta önce',
      'icon': Icons.work,
      'color': AppColors.primaryBlue,
      'type': 'job',
      'jobId': 2,
      'isUnread': false,
    },
    {
      'id': 6,
      'title': 'Eğitim Tamamlandı',
      'message': 'Zeytin hasadı eğitiminizi başarıyla tamamladınız.',
      'time': '2 hafta önce',
      'icon': Icons.celebration,
      'color': AppColors.green,
      'type': 'education',
      'courseId': 2,
      'isUnread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Bildirimler',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all, color: AppColors.primaryBlue),
            onPressed: () {
              setState(() {
                _notificationCount = 0;
                _notifications.clear(); // Tüm bildirimleri temizle
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tüm bildirimler temizlendi'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
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
                notification['isUnread'],
                notification,
              ),
              if (index < _notifications.length - 1) const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    String time,
    IconData icon,
    Color iconColor,
    bool isUnread,
    Map<String, dynamic> notification,
  ) {
    return GestureDetector(
      onTap: () {
        _handleNotificationTap(notification);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread 
              ? AppColors.primaryBlue.withValues(alpha: 0.3)
              : AppColors.cardBorder,
            width: isUnread ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İş ilanları sayfasına yönlendiriliyorsunuz...'),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
        break;
      case 'education':
        // Eğitim sayfasına git
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eğitim sayfasına yönlendiriliyorsunuz...'),
            backgroundColor: AppColors.green,
          ),
        );
        break;
      case 'message':
        // Mesaj sayfasına git (gelecekte eklenebilir)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mesaj özelliği yakında eklenecek'),
            backgroundColor: AppColors.orange,
          ),
        );
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