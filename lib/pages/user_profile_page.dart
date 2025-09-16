import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'help_support_page.dart';
import 'settings_page.dart';
import 'saved_items_page.dart';

class UserProfilePage extends StatefulWidget {
  final String role;
  final String name;
  final String email;
  final String phone;
  final String address;
  final VoidCallback? onLogout;
  final VoidCallback? onToggleDarkMode;

  const UserProfilePage({
    super.key,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.onLogout,
    this.onToggleDarkMode,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isEditing = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _phoneController.text = widget.phone;
    _addressController.text = widget.address;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isEmployer = widget.role == 'İşveren';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isSmallScreen ? 16 : 24,
            MediaQuery.of(context).padding.top + 20,
            isSmallScreen ? 16 : 24,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Profile Header
              _buildProfileHeader(isEmployer, isSmallScreen),
              const SizedBox(height: 32),

              // Personal Information
              _buildSectionTitle('Kişisel Bilgiler'),
              const SizedBox(height: 16),
              _buildPersonalInfoCard(isSmallScreen),
              const SizedBox(height: 24),

              // Role Specific Information
              _buildSectionTitle(isEmployer ? 'İşveren Bilgileri' : 'İşçi Bilgileri'),
              const SizedBox(height: 16),
              _buildRoleSpecificCard(isEmployer, isSmallScreen),
              const SizedBox(height: 24),

              // Statistics
              _buildSectionTitle('İstatistikler'),
              const SizedBox(height: 16),
              _buildStatisticsCard(isEmployer, isSmallScreen),
              const SizedBox(height: 24),

              // Actions
              _buildActionsCard(isEmployer, isSmallScreen),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isEmployer, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      decoration: BoxDecoration(
        gradient: isEmployer ? AppColors.primaryGradient : LinearGradient(
          colors: [AppColors.green, AppColors.green.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: Icon(
                  isEmployer ? Icons.business_center_rounded : Icons.construction_rounded,
                  size: 50,
                  color: AppColors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isEmployer ? AppColors.primaryBlue : AppColors.green,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: isEmployer ? AppColors.primaryBlue : AppColors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.name,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.role,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPersonalInfoCard(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Ad Soyad',
            value: _isEditing ? null : widget.name,
            controller: _nameController,
            isEditing: _isEditing,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'E-posta',
            value: widget.email,
            isEditing: false,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Telefon',
            value: _isEditing ? null : widget.phone,
            controller: _phoneController,
            isEditing: _isEditing,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Adres',
            value: _isEditing ? null : widget.address,
            controller: _addressController,
            isEditing: _isEditing,
            isMultiline: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    String? value,
    TextEditingController? controller,
    required bool isEditing,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              isEditing && controller != null
                  ? TextFormField(
                      controller: controller,
                      maxLines: isMultiline ? 3 : 1,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.cardBorder.withValues(alpha: 0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.cardBorder.withValues(alpha: 0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    )
                  : Text(
                      value ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificCard(bool isEmployer, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: isEmployer ? [
          _buildInfoRow(
            icon: Icons.business_center_rounded,
            label: 'Şirket Adı',
            value: 'Örnek Şirket A.Ş.',
            isEditing: false,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.work_rounded,
            label: 'Sektör',
            value: 'Tarım & İnşaat',
            isEditing: false,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.people_rounded,
            label: 'Çalışan Sayısı',
            value: '50-100',
            isEditing: false,
          ),
        ] : [
          _buildInfoRow(
            icon: Icons.work_rounded,
            label: 'Uzmanlık Alanı',
            value: 'Tarım İşçiliği',
            isEditing: false,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.star_rounded,
            label: 'Deneyim',
            value: '5+ Yıl',
            isEditing: false,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_rounded,
            label: 'Çalışma Bölgesi',
            value: 'Antalya, İzmir',
            isEditing: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(bool isEmployer, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: isEmployer ? [
          Expanded(
            child: _buildStatItem(
              icon: Icons.work_rounded,
              label: 'Aktif İlan',
              value: '12',
              color: AppColors.primaryBlue,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.cardBorder.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.people_rounded,
              label: 'Başvuru',
              value: '45',
              color: AppColors.green,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.cardBorder.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.star_rounded,
              label: 'Puan',
              value: '4.8',
              color: Colors.amber,
            ),
          ),
        ] : [
          Expanded(
            child: _buildStatItem(
              icon: Icons.work_rounded,
              label: 'Başvuru',
              value: '8',
              color: AppColors.primaryBlue,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.cardBorder.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.check_circle_rounded,
              label: 'Kabul',
              value: '5',
              color: AppColors.green,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.cardBorder.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.star_rounded,
              label: 'Puan',
              value: '4.9',
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard(bool isEmployer, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Kaydedilenler butonu
          _buildActionButton(
            icon: Icons.bookmark_rounded,
            label: 'Kaydedilenler',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedItemsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          
          // İlan Ver butonu (hem işveren hem işçi için)
          _buildActionButton(
            icon: isEmployer ? Icons.add_business_rounded : Icons.work_rounded,
            label: isEmployer ? 'İlan Ver' : 'Kendin İçin İlan Ver',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEmployer 
                        ? 'İlan verme sayfasına yönlendiriliyorsunuz...'
                        : 'Kendin için ilan verme sayfasına yönlendiriliyorsunuz...',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: AppColors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          
          _buildActionButton(
            icon: Icons.settings_rounded,
            label: 'Ayarlar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    role: widget.role,
                    name: widget.name,
                    email: widget.email,
                    onToggleDarkMode: widget.onToggleDarkMode,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.help_outline_rounded,
            label: 'Yardım & Destek',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.logout_rounded,
            label: 'Çıkış Yap',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Çıkış Yap',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  content: Text(
                    'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'İptal',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Ana sayfaya geri dön ve kullanıcı durumunu sıfırla
                        if (widget.onLogout != null) {
                          widget.onLogout!();
                        }
                        Navigator.popUntil(context, (route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Başarıyla çıkış yaptınız!',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Çıkış Yap',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: isDestructive 
            ? Colors.red.withValues(alpha: 0.1)
            : AppColors.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : AppColors.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: isDestructive ? Colors.red : AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
