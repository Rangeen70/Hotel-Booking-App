import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildSectionTitle('Personal Information'),
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Settings'),
            _buildSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.shade300,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'john.doe@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.phone, 'Phone', '+1 234 567 890'),
          const Divider(height: 24),
          _buildInfoRow(
              Icons.location_on, 'Address', '123 Main St, New York, USA'),
          const Divider(height: 24),
          _buildInfoRow(Icons.calendar_today, 'Date of Birth', 'Jan 1, 1990'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    final settings = [
      {
        'icon': Icons.notifications,
        'title': 'Notifications',
        'subtitle': 'Configure notification preferences',
        'trailing': Switch(value: true, onChanged: (value) {}),
      },
      {
        'icon': Icons.language,
        'title': 'Language',
        'subtitle': 'English (US)',
        'trailing': const Icon(Icons.chevron_right),
      },
      {
        'icon': Icons.dark_mode,
        'title': 'Dark Mode',
        'subtitle': 'Change app theme',
        'trailing': Switch(value: false, onChanged: (value) {}),
      },
      {
        'icon': Icons.help,
        'title': 'Help & Support',
        'subtitle': 'Contact us, FAQs, privacy policy',
        'trailing': const Icon(Icons.chevron_right),
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'subtitle': 'Sign out from your account',
        'trailing': const Icon(Icons.chevron_right),
        'color': Colors.red,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: settings.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final setting = settings[index];
          final isLogout = setting['title'] == 'Logout';

          return ListTile(
            leading: Icon(
              setting['icon'] as IconData,
              color: isLogout ? Colors.red : Colors.blue,
            ),
            title: Text(
              setting['title'] as String,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ),
            subtitle: Text(setting['subtitle'] as String),
            trailing: setting['trailing'] as Widget,
            onTap: () {},
          );
        },
      ),
    );
  }
}
