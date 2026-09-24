import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../models/job_data.dart';
import '../widgets/custom_drawer.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'saved_jobs_screen.dart';
import 'applications_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabIndex = 0;

  // In-memory state for saved jobs
  final Set<String> _savedJobIds = {'job-1', 'job-3'};

  // In-memory state for submitted applications
  final List<JobApplication> _submittedApplications = List.from(JobDummyData.sampleApplications);

  void _toggleBookmark(String jobId) {
    setState(() {
      if (_savedJobIds.contains(jobId)) {
        _savedJobIds.remove(jobId);
      } else {
        _savedJobIds.add(jobId);
      }
    });
  }

  void _onApplicationSubmitted(JobApplication application) {
    setState(() {
      _submittedApplications.add(application);
    });
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final List<Widget> pages = [
      HomeScreen(
        savedJobIds: _savedJobIds,
        onToggleBookmark: _toggleBookmark,
        onApplicationSubmitted: _onApplicationSubmitted,
        submittedApplications: _submittedApplications,
        onNavigateToTab: _navigateToTab,
      ),
      CategoriesScreen(
        savedJobIds: _savedJobIds,
        onToggleBookmark: _toggleBookmark,
        onApplicationSubmitted: _onApplicationSubmitted,
        submittedApplications: _submittedApplications,
      ),
      SavedJobsScreen(
        savedJobIds: _savedJobIds,
        onToggleBookmark: _toggleBookmark,
        onApplicationSubmitted: _onApplicationSubmitted,
        submittedApplications: _submittedApplications,
        onNavigateToExplore: _navigateToTab,
      ),
      ApplicationsScreen(
        applications: _submittedApplications,
        onNavigateToExplore: _navigateToTab,
      ),
    ];

    final List<String> titles = [
      'JobFinder',
      'Job Categories',
      'Saved Jobs',
      'Applications Tracker',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.work_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              titles[_currentTabIndex],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: isDark ? Colors.white70 : Colors.black87),
            tooltip: 'App Information',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    'JobFinder Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  content: Text(
                    'This Job Finder application demonstrates a complete job portal workflow including search, category filtering, detailed job specifications, interactive multi-field application forms with validations, bookmarks, and application tracking.',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade300 : Colors.black87,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Got it!'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      drawer: CustomDrawer(
        selectedIndex: _currentTabIndex,
        onSelectTab: _navigateToTab,
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
        savedCount: _savedJobIds.length,
        appliedCount: _submittedApplications.length,
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          currentIndex: _currentTabIndex,
          onTap: _navigateToTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.bookmark_outline_rounded),
                  if (_savedJobIds.isNotEmpty)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_savedJobIds.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.bookmark_rounded),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.assignment_outlined),
                  if (_submittedApplications.isNotEmpty)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_submittedApplications.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.assignment_turned_in_rounded),
              label: 'Applied',
            ),
          ],
        ),
      ),
    );
  }
}
