import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelectTab;
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;
  final int savedCount;
  final int appliedCount;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.savedCount,
    required this.appliedCount,
  });

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.work_outline_rounded, color: Color(0xFF2563EB)),
              const SizedBox(width: 10),
              Text(
                'About JobFinder',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'JobFinder is a mobile career platform built with vanilla Flutter widgets and zero external packages.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E3A8A).withOpacity(0.3) : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supported Components:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDarkMode ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Scaffold, AppBar, Drawer, BottomNavigationBar\n'
                      '• ListView, GridView, Stack, Card, Container\n'
                      '• TextField, TextFormField, DropdownButton\n'
                      '• Checkbox, Radio, Switch, SnackBar, AlertDialog',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: isDarkMode ? Colors.grey.shade300 : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
      child: Column(
        children: [
          // Drawer Header with User Profile info
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFFDBEAFE),
                        child: Icon(Icons.person_rounded, size: 36, color: Color(0xFF1D4ED8)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Raju Patel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'raju.patel@example.com',
                            style: TextStyle(
                              color: Color(0xFFBFDBFE),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Mini Stats Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$savedCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'Saved Jobs',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$appliedCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'Applied',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  title: 'Home & Explore',
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectTab(0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.grid_view_rounded,
                  title: 'Categories',
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectTab(1);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bookmark_rounded,
                  title: 'Saved Jobs',
                  badgeCount: savedCount,
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectTab(2);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assignment_turned_in_rounded,
                  title: 'My Applications',
                  badgeCount: appliedCount,
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectTab(3);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: isDarkMode ? const Color(0xFF334155) : Colors.grey.shade200),
                ),

                // Theme Switch Tile using standard Switch widget
                SwitchListTile(
                  secondary: Icon(
                    isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                  ),
                  title: Text(
                    'Dark Theme Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  value: isDarkMode,
                  activeColor: const Color(0xFF2563EB),
                  onChanged: onToggleTheme,
                ),

                ListTile(
                  leading: Icon(
                    Icons.info_outline_rounded,
                    color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                  ),
                  title: Text(
                    'About App',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              'JobFinder v1.0.0 • Pure Flutter',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    Color itemBg = Colors.transparent;
    Color iconColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;
    Color textColor = isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800;

    if (isSelected) {
      itemBg = isDarkMode ? const Color(0xFF1E3A8A).withOpacity(0.5) : const Color(0xFFEFF6FF);
      iconColor = isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
      textColor = isDarkMode ? Colors.white : const Color(0xFF1E40AF);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: itemBg,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
          trailing: (badgeCount != null && badgeCount > 0)
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : (isDarkMode ? const Color(0xFF334155) : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
