import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/worker.dart';
import '../models/chat_room.dart';
import '../models/review.dart';
import 'chat_detail_page.dart';
import '../utils/colors.dart';
import 'worker_detail_page.dart';

class WorkerListingsPage extends StatefulWidget {
  const WorkerListingsPage({super.key});

  @override
  State<WorkerListingsPage> createState() => _WorkerListingsPageState();
}

class _WorkerListingsPageState extends State<WorkerListingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Önerilen';
  List<Worker> _filteredWorkers = [];
  List<Worker> _allWorkers = [];
  List<String> _filters = ['Önerilen', 'En Yeni', 'En Eski', 'En Yüksek Ücret', 'En Düşük Ücret'];
  bool _onlyAvailable = false;

  @override
  void initState() {
    super.initState();
    _allWorkers = _generateSampleWorkers();
    _filteredWorkers = List.from(_allWorkers);
    _searchController.addListener(_filterWorkers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterWorkers() {
    setState(() {
      final searchText = _searchController.text.toLowerCase();
      
      _filteredWorkers = _allWorkers.where((worker) {
        final matchesSearch = worker.name.toLowerCase().contains(searchText) ||
            worker.description.toLowerCase().contains(searchText) ||
            worker.skills.any((skill) => skill.toLowerCase().contains(searchText));

        final matchesAvailability = !_onlyAvailable || worker.isAvailable;

        return matchesSearch && matchesAvailability;
      }).toList();
      
      _applySorting();
    });
  }

  void _applySorting() {
    switch (_selectedFilter) {
      case 'Önerilen':
        // Keep original order
        break;
      case 'En Yeni':
        _filteredWorkers.sort((a, b) => b.postedDate.compareTo(a.postedDate));
        break;
      case 'En Eski':
        _filteredWorkers.sort((a, b) => a.postedDate.compareTo(b.postedDate));
        break;
      case 'En Yüksek Ücret':
        _filteredWorkers.sort((a, b) => b.hourlyRate.compareTo(a.hourlyRate));
        break;
      case 'En Düşük Ücret':
        _filteredWorkers.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isSmallScreen),
            _buildSearchAndFilter(context, isSmallScreen),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                itemCount: _filteredWorkers.length,
                itemBuilder: (context, index) {
                  final worker = _filteredWorkers[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
                    child: _buildWorkerCard(worker),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue, // Aynı ton rengi için gradient yerine solid color
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
                      'İşçi İlanları',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 8),
                    Text(
                      'Size uygun işçileri keşfedin',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue, // Aynı ton rengi için gradient yerine solid color
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: AppColors.searchBackground,
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
                    controller: _searchController,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _showFilterBottomSheet(context),
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
          SizedBox(height: isSmallScreen ? 8 : 12),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(child: _buildFilterChip(filter)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(Worker worker) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerDetailPage(worker: worker),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.cardBorder.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: isSmallScreen ? 40 : 48,
                  height: isSmallScreen ? 40 : 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        worker.name,
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 13 : 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 1 : 2),
                      Text(
                        '${worker.experience} deneyim',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 11 : 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 6 : 8,
                    vertical: isSmallScreen ? 3 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: worker.isAvailable 
                        ? AppColors.success.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    worker.isAvailable ? 'Müsait' : 'Müsait Değil',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 9 : 11,
                      fontWeight: FontWeight.w500,
                      color: worker.isAvailable ? AppColors.success : Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: isSmallScreen ? 12 : 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: isSmallScreen ? 3 : 4),
                        Flexible(
                          child: Text(
                            worker.location,
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 11 : 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: isSmallScreen ? 12 : 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: isSmallScreen ? 3 : 4),
                        Flexible(
                          child: Text(
                            worker.experience,
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 11 : 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 10),
            Text(
              worker.description,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 11 : 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isSmallScreen ? 8 : 10),
            Wrap(
              spacing: isSmallScreen ? 3 : 4,
              runSpacing: isSmallScreen ? 3 : 4,
              children: worker.skills.map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 6 : 8,
                    vertical: isSmallScreen ? 3 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cardBorder.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 9 : 11,
                      color: AppColors.textSecondary,
                      height: 1.2,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: isSmallScreen ? 12 : 14,
                        color: Colors.amber,
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
                      Text(
                        worker.rating.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 11 : 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
                      Flexible(
                        child: Text(
                          '(${worker.completedJobs} değerlendirme)',
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 9 : 11,
                            color: AppColors.textSecondary,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final chatRoom = ChatRoom(
                      id: 'worker_${worker.id}',
                      otherUserId: worker.id,
                      otherUserName: worker.name,
                      otherUserImageUrl: '',
                      lastMessage: '',
                      lastMessageTime: DateTime.now(),
                      unreadCount: 0,
                      isOnline: worker.isAvailable,
                    );
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailPage(chatRoom: chatRoom),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 10,
                      vertical: isSmallScreen ? 4 : 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'İletişime Geç',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
                      Icon(
                        Icons.message_outlined,
                        size: isSmallScreen ? 12 : 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      margin: EdgeInsets.only(right: isSmallScreen ? 6 : 8),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 11 : 12,
            fontWeight: _selectedFilter == label ? FontWeight.w600 : FontWeight.w400,
            color: _selectedFilter == label ? AppColors.primaryBlue : AppColors.textSecondary,
          ),
        ),
        selected: _selectedFilter == label,
        onSelected: (selected) {
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkerFilterModal(
        onlyAvailable: _onlyAvailable,
        onAvailabilityChanged: (available) {
          setState(() {
            _onlyAvailable = available;
          });
          _filterWorkers();
        },
      ),
    );
  }

  List<Worker> _generateSampleWorkers() {
    final now = DateTime.now();
    return [
      Worker(
        id: '1',
        name: 'Ahmet Yılmaz',
        age: 35,
        location: 'Antalya, Merkez',
        experience: '5 yıl',
        skills: ['Sera Yetiştiriciliği', 'Hasat', 'Sulama'],
        description: 'Sera yetiştiriciliği konusunda 5 yıllık deneyime sahibim. Modern sera sistemlerinde çalıştım.',
        expectedSalary: 5500,
        availability: 'Tam zamanlı',
        postedDate: now.subtract(const Duration(days: 3)),
        contactInfo: '0555 111 2233',
        hourlyRate: 75.0,
        isAvailable: true,
        profileImage: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
        rating: 4.8,
        completedJobs: 127,
        reviews: [
          Review(
            id: '1',
            userId: 'user1',
            userName: 'Mehmet Demir',
            userImage: '',
            rating: 5.0,
            comment: 'Çok profesyonel ve işinin ehli',
            createdAt: now.subtract(const Duration(days: 5)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Worker(
        id: '2',
        name: 'Ayşe Kaya',
        age: 28,
        location: 'İzmir, Menderes',
        experience: '3 yıl',
        skills: ['Organik Tarım', 'Sebze Yetiştiriciliği', 'Budama'],
        description: 'Organik tarım sertifikasına sahibim. Sebze ve meyve yetiştiriciliğinde uzmanım.',
        expectedSalary: 4800,
        availability: 'Tam zamanlı',
        postedDate: now.subtract(const Duration(days: 1)),
        contactInfo: '0555 444 5566',
        hourlyRate: 65.0,
        isAvailable: true,
        profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
        rating: 4.5,
        completedJobs: 84,
        reviews: [
          Review(
            id: '2',
            userId: 'user2',
            userName: 'Ali Yıldız',
            userImage: '',
            rating: 4.5,
            comment: 'İşini zamanında ve özenle yapıyor',
            createdAt: now.subtract(const Duration(days: 2)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      Worker(
        id: '3',
        name: 'Mehmet Demir',
        age: 42,
        location: 'Manisa, Alaşehir',
        experience: '7 yıl',
        skills: ['Bağcılık', 'Budama', 'İlaçlama'],
        description: 'Bağcılık konusunda uzun yıllar deneyimli. Budama ve bakım işlerinde profesyonel.',
        expectedSalary: 6000,
        availability: 'Tam zamanlı',
        postedDate: now,
        contactInfo: '0555 777 8899',
        hourlyRate: 85.0,
        isAvailable: false,
        profileImage: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
        rating: 4.9,
        completedJobs: 156,
        reviews: [
          Review(
            id: '3',
            userId: 'user3',
            userName: 'Zeynep Kara',
            userImage: '',
            rating: 5.0,
            comment: 'Bağ bakımında çok tecrübeli',
            createdAt: now.subtract(const Duration(days: 1)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 45)),
      ),
    ];
  }
}

class WorkerFilterModal extends StatefulWidget {
  final bool onlyAvailable;
  final Function(bool) onAvailabilityChanged;

  const WorkerFilterModal({
    super.key,
    required this.onlyAvailable,
    required this.onAvailabilityChanged,
  });

  @override
  State<WorkerFilterModal> createState() => _WorkerFilterModalState();
}

class _WorkerFilterModalState extends State<WorkerFilterModal> {
  late bool onlyAvailable;
  String selectedDistance = 'En yakındaki';
  String selectedDuration = 'Günlük işler';
  String selectedSector = 'Tüm sektörler';
  String selectedRating = 'Tüm puanlar';
  double minSalary = 0;
  double maxSalary = 1000;

  @override
  void initState() {
    super.initState();
    onlyAvailable = widget.onlyAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final modalHeight = screenHeight * 0.8 + keyboardHeight;
    
    return Container(
      height: modalHeight > screenHeight * 0.9 ? screenHeight * 0.9 : modalHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
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
                    [
                      'En yakındaki',
                      '5 km içinde',
                      '10 km içinde',
                      '20 km içinde',
                      '50 km içinde',
                    ],
                    selectedDistance,
                    (value) => setState(() => selectedDistance = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Süre Filtresi
                  _buildFilterSection(
                    'İş Süresi',
                    [
                      'Günlük işler',
                      'Haftalık işler',
                      'Aylık işler',
                      'Sürekli işler',
                    ],
                    selectedDuration,
                    (value) => setState(() => selectedDuration = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Sektör Filtresi
                  _buildFilterSection(
                    'Sektör',
                    [
                      'Tüm sektörler',
                      'Tarım',
                      'İnşaat',
                      'Hizmet',
                      'Sanayi',
                      'Cafe/Restoran',
                    ],
                    selectedSector,
                    (value) => setState(() => selectedSector = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Puan Filtresi
                  _buildFilterSection(
                    'Puan Durumu',
                    [
                      'Tüm puanlar',
                      '4.5+ yıldız',
                      '4.0+ yıldız',
                      '3.5+ yıldız',
                      '3.0+ yıldız',
                    ],
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
                          widget.onAvailabilityChanged(value ?? false);
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

  Widget _buildFilterSection(String title, List<String> options, String selected, Function(String) onChanged) {
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
            final isSelected = selected == option;
            return InkWell(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
                    width: 1,
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