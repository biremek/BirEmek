import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biremek/models/worker.dart';
import 'package:biremek/utils/colors.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({super.key});

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  int _notificationCount = 3; // Bildirim sayısı
  String _selectedFilter = 'Tümü'; // Seçili filtre

  // İşçi filtreleri
  final List<String> _workerFilters = [
    'Tümü',
    'En Yüksek Ücret',
    'En Düşük Ücret',
    'En Yakın',
    'En Yüksek Puan',
    'Müsait',
  ];

  // Bildirim verileri
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Yeni İşçi Başvurusu',
      'message': 'Mehmet Yılmaz iş ilanınıza başvurdu',
      'time': '1 saat önce',
      'icon': Icons.person_add,
      'color': AppColors.primaryBlue,
      'type': 'application',
    },
    {
      'id': 2,
      'title': 'Mesaj',
      'message': 'Ayşe Demir size mesaj gönderdi',
      'time': '3 saat önce',
      'icon': Icons.message,
      'color': AppColors.orange,
      'type': 'message',
    },
    {
      'id': 3,
      'title': 'Sistem Bildirimi',
      'message': 'İlanınız başarıyla yayınlandı',
      'time': '1 gün önce',
      'icon': Icons.info,
      'color': AppColors.green,
      'type': 'system',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildWorkerList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: AppColors.searchBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.cardBorder,
                      width: 1,
                    ),
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
                            hintText: 'İşçi ara',
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: isSmallScreen ? 13 : 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () => _showFilterModal(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_list_rounded,
                                color: AppColors.primaryBlue,
                                size: isSmallScreen ? 16 : 18,
                              ),
                              SizedBox(width: isSmallScreen ? 3 : 4),
                              Text(
                                'Filtrele',
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 11 : 12,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showNotificationsDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: AppColors.iconPrimary,
                      ),
                    ),
                  ),
                  if (_notificationCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
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
          SizedBox(height: isSmallScreen ? 8 : 12),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: _workerFilters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(child: _buildFilterChip(context, filter)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sampleWorkers.length,
      itemBuilder: (context, index) {
        final worker = sampleWorkers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.lightBlue,
              child: Text(
                worker.name[0],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            title: Row(
              children: [
                Text(
                  worker.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.verified,
                  color: AppColors.orange,
                  size: 20,
                ),
              ],
            ),
            subtitle: Text(
              '${worker.expectedSalary.toStringAsFixed(0)} TL/saat',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Hire',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.navInactive,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_list),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
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
                        _notifications.clear();
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
      case 'application':
        // İşçi başvurusu sayfasına git
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşçi başvuruları sayfasına yönlendiriliyorsunuz...'),
            backgroundColor: AppColors.primaryBlue,
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

  Widget _buildFilterChip(BuildContext context, String label) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    // Küçük ekranlar için daha kısa etiketler
    String displayLabel = label;
    if (isSmallScreen) {
      switch (label) {
        case 'En Yüksek Ücret':
          displayLabel = 'En Yüksek';
          break;
        case 'En Düşük Ücret':
          displayLabel = 'En Düşük';
          break;
        case 'En Yüksek Puan':
          displayLabel = 'En Yüksek';
          break;
      }
    }
    
    return Container(
      margin: EdgeInsets.only(right: isSmallScreen ? 6 : 8),
      child: FilterChip(
        label: Text(
          displayLabel,
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 11 : 12,
            fontWeight: _selectedFilter == label ? FontWeight.w600 : FontWeight.w400,
            color: _selectedFilter == label ? AppColors.primaryBlue : AppColors.textSecondary,
          ),
        ),
        selected: _selectedFilter == label,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = label;
          });
          _filterWorkers();
        },
        backgroundColor: _selectedFilter == label ? AppColors.primaryBlue.withValues(alpha: 0.1) : AppColors.searchBackground,
        selectedColor: AppColors.primaryBlue.withValues(alpha: 0.1),
        checkmarkColor: AppColors.primaryBlue,
        side: BorderSide(
          color: _selectedFilter == label ? AppColors.primaryBlue : AppColors.cardBorder,
          width: 1,
        ),
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12, vertical: isSmallScreen ? 4 : 6),
      ),
    );
  }

  void _filterWorkers() {
    // İşçi filtreleme mantığı burada uygulanacak
    // Şimdilik sadece setState çağırıyoruz
    setState(() {
      // Filtreleme işlemi
    });
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkerFilterModal(),
    );
  }
}

class WorkerFilterModal extends StatefulWidget {
  @override
  _WorkerFilterModalState createState() => _WorkerFilterModalState();
}

class _WorkerFilterModalState extends State<WorkerFilterModal> {
  String selectedDistance = 'En yakındaki';
  String selectedDuration = 'Günlük işler';
  String selectedSector = 'Tüm sektörler';
  String selectedRating = 'Tüm puanlar';
  double minSalary = 0;
  double maxSalary = 1000;
  bool onlyAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.cardBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtreleme Seçenekleri',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Mesafe Filtresi
                  _buildFilterSection(
                    'Mesafe',
                    ['En yakındaki', '5 km içinde', '10 km içinde', '20 km içinde', '50 km içinde'],
                    selectedDistance,
                    (value) => setState(() => selectedDistance = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Süre Filtresi
                  _buildFilterSection(
                    'İş Süresi',
                    ['Günlük işler', 'Haftalık işler', 'Aylık işler', 'Sürekli işler'],
                    selectedDuration,
                    (value) => setState(() => selectedDuration = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Sektör Filtresi
                  _buildFilterSection(
                    'Sektör',
                    ['Tüm sektörler', 'Tarım', 'İnşaat', 'Hizmet', 'Sanayi', 'Cafe/Restoran'],
                    selectedSector,
                    (value) => setState(() => selectedSector = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Puan Filtresi
                  _buildFilterSection(
                    'Puan Durumu',
                    ['Tüm puanlar', '4.5+ yıldız', '4.0+ yıldız', '3.5+ yıldız', '3.0+ yıldız'],
                    selectedRating,
                    (value) => setState(() => selectedRating = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Günlük Maaş Aralığı
                  Text(
                    'Günlük Maaş Aralığı',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Min',
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '-',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Max',
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Müsaitlik Filtresi
                  Row(
                    children: [
                      Checkbox(
                        value: onlyAvailable,
                        onChanged: (value) {
                          setState(() {
                            onlyAvailable = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                      ),
                      Text(
                        'Sadece müsait olanlar',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Butonlar
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Temizle',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Filtreleme işlemi
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Filtreler uygulandı!'),
                                backgroundColor: AppColors.primaryBlue,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Uygula',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
} 