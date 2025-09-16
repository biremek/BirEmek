import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'app_rating_page.dart';
import 'about_page.dart';
import 'change_password_page.dart';
import 'change_email_page.dart';
import 'profile_info_page.dart';

class SettingsPage extends StatefulWidget {
  final String role;
  final String name;
  final String email;
  final VoidCallback? onToggleDarkMode;

  const SettingsPage({
    super.key,
    required this.role,
    required this.name,
    required this.email,
    this.onToggleDarkMode,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  String _selectedLanguage = 'Türkçe';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isEmployer = widget.role == 'İşveren';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ayarlar',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Profile Section
              _buildProfileSection(isEmployer, isSmallScreen),
              const SizedBox(height: 32),

              // Account Settings
              _buildSectionTitle('Hesap Ayarları'),
              const SizedBox(height: 16),
              _buildAccountSettingsCard(isSmallScreen),
              const SizedBox(height: 24),

              // Notification Settings
              _buildSectionTitle('Bildirim Ayarları'),
              const SizedBox(height: 16),
              _buildNotificationSettingsCard(isSmallScreen),
              const SizedBox(height: 24),

              // App Settings
              _buildSectionTitle('Uygulama Ayarları'),
              const SizedBox(height: 16),
              _buildAppSettingsCard(isSmallScreen),
              const SizedBox(height: 24),

              // Privacy & Security
              _buildSectionTitle('Gizlilik ve Güvenlik'),
              const SizedBox(height: 16),
              _buildPrivacySettingsCard(isSmallScreen),
              const SizedBox(height: 24),

              // About Section
              _buildSectionTitle('Hakkında'),
              const SizedBox(height: 16),
              _buildAboutCard(isSmallScreen),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isEmployer, bool isSmallScreen) {
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              isEmployer ? Icons.business_center_rounded : Icons.construction_rounded,
              size: 30,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.role,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
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

  Widget _buildAccountSettingsCard(bool isSmallScreen) {
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
          _buildSettingsItem(
            icon: Icons.person_outline_rounded,
            title: 'Profil Bilgileri',
            subtitle: 'Ad, telefon ve adres bilgilerinizi düzenleyin',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileInfoPage(
                    role: widget.role,
                    name: widget.name,
                    email: widget.email,
                  ),
                ),
              );
            },
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.email_outlined,
            title: 'E-posta Değiştir',
            subtitle: 'E-posta adresinizi güncelleyin',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeEmailPage(
                    currentEmail: widget.email,
                  ),
                ),
              );
            },
            color: AppColors.green,
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.lock_outline_rounded,
            title: 'Şifre Değiştir',
            subtitle: 'Hesap güvenliğiniz için şifrenizi güncelleyin',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordPage(),
                ),
              );
            },
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettingsCard(bool isSmallScreen) {
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
          _buildSwitchItem(
            icon: Icons.notifications_outlined,
            title: 'Bildirimler',
            subtitle: 'Tüm bildirimleri aç/kapat',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                if (!value) {
                  _emailNotifications = false;
                  _pushNotifications = false;
                  _smsNotifications = false;
                }
              });
            },
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            icon: Icons.email_outlined,
            title: 'E-posta Bildirimleri',
            subtitle: 'E-posta ile bildirim al',
            value: _emailNotifications,
            onChanged: _notificationsEnabled ? (value) {
              setState(() {
                _emailNotifications = value;
              });
            } : null,
            color: AppColors.green,
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            icon: Icons.phone_android_outlined,
            title: 'Uygulama Bildirimleri',
            subtitle: 'Uygulama bildirimleri al',
            value: _pushNotifications,
            onChanged: _notificationsEnabled ? (value) {
              setState(() {
                _pushNotifications = value;
              });
            } : null,
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            icon: Icons.sms_outlined,
            title: 'SMS Bildirimleri',
            subtitle: 'SMS ile bildirim al',
            value: _smsNotifications,
            onChanged: _notificationsEnabled ? (value) {
              setState(() {
                _smsNotifications = value;
              });
            } : null,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsCard(bool isSmallScreen) {
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
          _buildDropdownItem(
            icon: Icons.language_rounded,
            title: 'Dil',
            subtitle: 'Uygulama dilini seçin',
            value: _selectedLanguage,
            options: ['Türkçe', 'English'],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            icon: Icons.dark_mode_outlined,
            title: 'Koyu Mod',
            subtitle: 'Koyu tema kullan',
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              _toggleDarkMode();
            },
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettingsCard(bool isSmallScreen) {
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
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Gizlilik Politikası',
            subtitle: 'Veri kullanımı ve gizlilik haklarınız',
            onTap: () => _showComingSoon('Gizlilik Politikası'),
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.security_outlined,
            title: 'Güvenlik Ayarları',
            subtitle: 'Hesap güvenliği ve iki faktörlü doğrulama',
            onTap: () => _showComingSoon('Güvenlik Ayarları'),
            color: AppColors.green,
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.delete_outline_rounded,
            title: 'Hesabı Sil',
            subtitle: 'Hesabınızı kalıcı olarak silin',
            onTap: () => _showDeleteAccountDialog(),
            color: Colors.red,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(bool isSmallScreen) {
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
          _buildSettingsItem(
            icon: Icons.info_outline_rounded,
            title: 'Uygulama Hakkında',
            subtitle: 'Şirket bilgileri ve misyonumuz',
            onTap: () => _navigateToAboutPage(),
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.star_outline_rounded,
            title: 'Uygulamayı Değerlendir',
            subtitle: 'Görüşlerinizi paylaşın',
            onTap: () => _navigateToRatingPage(),
            color: Colors.amber,
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.share_outlined,
            title: 'Uygulamayı Paylaş',
            subtitle: 'Arkadaşlarınızla paylaşın',
            onTap: () => _showComingSoon('Uygulama Paylaşımı'),
            color: AppColors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive 
            ? Colors.red.withValues(alpha: 0.05)
            : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive 
              ? Colors.red.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive 
                  ? Colors.red.withValues(alpha: 0.1)
                  : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            underline: const SizedBox(),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature özelliği yakında eklenecek!',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }


  void _toggleDarkMode() {
    // Ana uygulamaya koyu mod değişikliğini bildir
    if (widget.onToggleDarkMode != null) {
      widget.onToggleDarkMode!();
    }
    
    // Tema değişikliği için snackbar göster
    final currentBrightness = Theme.of(context).brightness;
    final newBrightness = currentBrightness == Brightness.dark 
        ? Brightness.light 
        : Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newBrightness == Brightness.dark 
              ? 'Koyu mod etkinleştirildi' 
              : 'Açık mod etkinleştirildi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: newBrightness == Brightness.dark 
            ? Colors.grey[800] 
            : AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToRatingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AppRatingPage(),
      ),
    );
  }

  void _navigateToAboutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutPage(),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hesabı Sil',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinecektir.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
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
              _showComingSoon('Hesap Silme');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Sil',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
