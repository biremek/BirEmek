import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biremek/models/job.dart';
import 'package:biremek/pages/job_detail_page.dart';
import 'package:biremek/utils/colors.dart';

final List<Job> jobs = [
  Job(
    id: '1',
    title: 'Zeytin toplama ve yazgı yazma için eleman aranıyor',
    description: 'Zeytin toplama ve yazgı yazma işlerinde çalışacak deneyimli personel aranmaktadır.',
    location: 'Muğla/Milas',
    category: 'Zeytin',
    companyName: 'Sevgül Zeytincilik',
    companyLogo: 'https://picsum.photos/200/200?random=1',
    employerName: 'Emir Sevgül',
    dailyWage: 450.0,
    postedAt: '2 gün önce',
    reviews: [
      JobReview(
        id: '1',
        userName: 'Ahmet Yılmaz',
        userImage: 'https://picsum.photos/150/150?random=2',
        comment: 'Çok güzel bir iş ortamı. İşveren çok anlayışlı ve ücretler zamanında ödeniyor. Kesinlikle tavsiye ederim.',
        rating: 4.5,
        date: '1 hafta önce',
        isVerifiedWorker: true,
      ),
      JobReview(
        id: '2',
        userName: 'Fatma Demir',
        userImage: 'https://picsum.photos/150/150?random=3',
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
    companyLogo: 'https://picsum.photos/200/200?random=4',
    employerName: 'Nurullah Taniş',
    dailyWage: 500.0,
    postedAt: '15 gün önce',
    reviews: [
      JobReview(
        id: '3',
        userName: 'Mehmet Kaya',
        userImage: 'https://picsum.photos/150/150?random=5',
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
    companyLogo: 'https://picsum.photos/200/200?random=6',
    employerName: 'Oğuz Bulan',
    dailyWage: 400.0,
    postedAt: 'Bugün',
    reviews: [],
    jobType: 'Tam Zamanlı',
    duration: 'Bugün',
    requirements: ['Bulaşık Yıkama', 'Temizlik', 'Düzen'],
    benefits: ['Yemek'],
  ),
];

class JobListingsPage extends StatefulWidget {
  const JobListingsPage({super.key});

  @override
  State<JobListingsPage> createState() => _JobListingsPageState();
}

class _JobListingsPageState extends State<JobListingsPage> {
  String _selectedFilter = 'Önerilen';
  List<Job> _filteredJobs = [];
  List<Job> _allJobs = [];
  List<String> _filters = ['Önerilen', 'En Yeni', 'En Eski', 'En Yüksek Ücret', 'En Düşük Ücret'];

  @override
  void initState() {
    super.initState();
    _allJobs = List.from(jobs);
    _filteredJobs = List.from(_allJobs);
  }

  void _filterJobs() {
    setState(() {
      switch (_selectedFilter) {
        case 'Önerilen':
          _filteredJobs = List.from(_allJobs);
          break;
        case 'En Yeni':
          _filteredJobs = List.from(_allJobs);
          _filteredJobs.sort((a, b) {
            // Basit bir sıralama - gerçek uygulamada tarih karşılaştırması yapılır
            return a.postedAt.compareTo(b.postedAt);
          });
          break;
        case 'En Eski':
          _filteredJobs = List.from(_allJobs);
          _filteredJobs.sort((a, b) {
            return b.postedAt.compareTo(a.postedAt);
          });
          break;
        case 'En Yüksek Ücret':
          _filteredJobs = List.from(_allJobs);
          _filteredJobs.sort((a, b) => b.dailyWage.compareTo(a.dailyWage));
          break;
        case 'En Düşük Ücret':
          _filteredJobs = List.from(_allJobs);
          _filteredJobs.sort((a, b) => a.dailyWage.compareTo(b.dailyWage));
          break;
      }
    });
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
                itemCount: _filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = _filteredJobs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailPage(job: job),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                                  decoration: BoxDecoration(
                                    color: _getColorForCategory(job.category).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getIconForCategory(job.category),
                                    color: _getColorForCategory(job.category),
                                    size: isSmallScreen ? 18 : 20,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 8 : 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: isSmallScreen ? 6 : 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: isSmallScreen ? 12 : 14,
                                            color: AppColors.textSecondary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            job.location,
                                            style: GoogleFonts.poppins(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: isSmallScreen ? 8 : 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '₺',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primaryBlue,
                                                  ),
                                                ),
                                                Text(
                                                  '${job.dailyWage.toStringAsFixed(0)}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primaryBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            job.postedAt,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: AppColors.textLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Yorum ve puanlama bilgisi
                            if (job.reviewCount > 0) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.searchBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 2),
                                              child: Icon(
                                                index < job.averageRating.floor()
                                                    ? Icons.star
                                                    : index < job.averageRating
                                                        ? Icons.star_half
                                                        : Icons.star_border,
                                                size: 14,
                                                color: Colors.amber,
                                              ),
                                            );
                                          }),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${job.averageRating.toStringAsFixed(1)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(${job.reviewCount} yorum)',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6 : 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.rate_review,
                                              size: isSmallScreen ? 12 : 14,
                                              color: AppColors.primaryBlue,
                                            ),
                                            SizedBox(width: isSmallScreen ? 3 : 4),
                                            Text(
                                              'Yorum yap',
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
                            ] else ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.searchBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_border,
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Henüz yorum yok',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6 : 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.rate_review,
                                              size: isSmallScreen ? 12 : 14,
                                              color: AppColors.primaryBlue,
                                            ),
                                            SizedBox(width: isSmallScreen ? 3 : 4),
                                            Text(
                                              'İlk yorumu yap',
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
                            ],
                          ],
                        ),
                      ),
                    ),
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
                      'İş İlanları',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 8),
                    Text(
                      'Size uygun işleri keşfedin',
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
      color: AppColors.white,
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
                      hintText: 'İş ara',
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
          SizedBox(height: isSmallScreen ? 8 : 12),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: _filters.map((filter) {
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

  Widget _buildFilterChip(BuildContext context, String label, [bool isSelected = false]) {
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
        case 'İş İlanları':
          displayLabel = 'İşler';
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
          _filterJobs();
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

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'zeytin':
        return AppColors.green;
      case 'inşaat':
        return AppColors.orange;
      case 'cafe':
        return AppColors.primaryBlue;
      case 'ev temizliği':
        return AppColors.pink;
      case 'çay':
        return AppColors.green;
      default:
        return AppColors.primaryBlue;
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'zeytin':
        return Icons.eco_rounded;
      case 'inşaat':
        return Icons.construction_rounded;
      case 'cafe':
        return Icons.restaurant_rounded;
      case 'ev temizliği':
        return Icons.cleaning_services_rounded;
      case 'çay':
        return Icons.factory_rounded;
      default:
        return Icons.work_rounded;
    }
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModal(),
    );
  }
}

class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String selectedDistance = 'En yakındaki';
  String selectedDuration = 'Günlük işler';
  String selectedSector = 'Tüm sektörler';
  String selectedRating = 'Tüm puanlar';
  double minSalary = 0;
  double maxSalary = 1000;

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
                  
                  // Maaş Aralığı
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