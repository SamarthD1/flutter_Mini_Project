import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../models/job_data.dart';
import '../widgets/job_card.dart';
import '../widgets/category_card.dart';
import 'job_details_screen.dart';
import 'application_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final Set<String> savedJobIds;
  final Function(String) onToggleBookmark;
  final Function(JobApplication) onApplicationSubmitted;
  final List<JobApplication> submittedApplications;
  final Function(int) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.savedJobIds,
    required this.onToggleBookmark,
    required this.onApplicationSubmitted,
    required this.submittedApplications,
    required this.onNavigateToTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategoryFilter = 'all';
  String _selectedWorkplaceFilter = 'All'; // All, Remote, Hybrid, On-site

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Opportunities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: isDark ? Colors.white70 : Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  Divider(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200),
                  const SizedBox(height: 8),
                  Text(
                    'Workplace Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Remote', 'Hybrid', 'On-site'].map((type) {
                      final isSelected = _selectedWorkplaceFilter == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: const Color(0xFF2563EB),
                        backgroundColor: isDark ? const Color(0xFF334155) : Colors.grey.shade100,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => _selectedWorkplaceFilter = type);
                            setState(() => _selectedWorkplaceFilter = type);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() => _selectedWorkplaceFilter = 'All');
                            setState(() => _selectedWorkplaceFilter = 'All');
                            Navigator.pop(ctx);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                            side: BorderSide(
                              color: isDark ? const Color(0xFF475569) : Colors.grey.shade300,
                            ),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply Filter'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter jobs
    final filteredJobs = JobDummyData.allJobs.where((job) {
      final matchesSearch = _searchQuery.isEmpty ||
          job.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job.company.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job.skills.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchesCategory =
          _selectedCategoryFilter == 'all' || job.categoryId == _selectedCategoryFilter;

      final matchesWorkplace =
          _selectedWorkplaceFilter == 'All' || job.workplaceType == _selectedWorkplaceFilter;

      return matchesSearch && matchesCategory && matchesWorkplace;
    }).toList();

    final featuredJobs = JobDummyData.allJobs.where((j) => j.isFeatured).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              children: [
                // Welcome Greeting Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Your Dream Role',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Explore ${JobDummyData.allJobs.length}+ curated job openings',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E3A8A).withOpacity(0.4)
                            : Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Search Bar TextField + Filter Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _searchQuery = value.trim()),
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 14,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                            hintText: 'Search title, company, skills...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                              size: 22,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      size: 18,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF2563EB),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Material(
                        color: _selectedWorkplaceFilter != 'All'
                            ? const Color(0xFF2563EB)
                            : (isDark ? const Color(0xFF1E293B) : Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _selectedWorkplaceFilter != 'All'
                                ? const Color(0xFF2563EB)
                                : (isDark ? const Color(0xFF334155) : Colors.grey.shade200),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _showFilterModal,
                          child: Center(
                            child: Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: _selectedWorkplaceFilter != 'All'
                                  ? Colors.white
                                  : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Categories horizontal slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Categories',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigateToTab(1), // Go to categories tab
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // 'All' category chip
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('All Jobs'),
                          selected: _selectedCategoryFilter == 'all',
                          selectedColor: const Color(0xFF2563EB),
                          backgroundColor:
                              isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                          labelStyle: TextStyle(
                            color: _selectedCategoryFilter == 'all'
                                ? Colors.white
                                : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (selected) {
                            setState(() => _selectedCategoryFilter = 'all');
                          },
                        ),
                      ),
                      ...JobDummyData.categories.map((cat) {
                        final isSelected = _selectedCategoryFilter == cat.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryCard(
                            category: cat,
                            isCompact: true,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedCategoryFilter = isSelected ? 'all' : cat.id;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Featured Jobs Carousel
                if (_searchQuery.isEmpty && _selectedCategoryFilter == 'all') ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Opportunities',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF78350F).withOpacity(0.5)
                              : Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${featuredJobs.length} Hot',
                          style: TextStyle(
                            color: isDark ? const Color(0xFFFBBF24) : Colors.amber.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredJobs.length,
                      itemBuilder: (context, index) {
                        final job = featuredJobs[index];
                        final isSaved = widget.savedJobIds.contains(job.id);
                        final hasApplied =
                            widget.submittedApplications.any((a) => a.jobId == job.id);
                        return JobCard(
                          job: job,
                          isSaved: isSaved,
                          isFeaturedCard: true,
                          onTap: () => _openJobDetails(job, isSaved, hasApplied),
                          onBookmarkToggle: () => widget.onToggleBookmark(job.id),
                          onApply: () => _openApplicationForm(job),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Recent Postings Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchQuery.isNotEmpty ? 'Search Results' : 'Recent Job Postings',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${filteredJobs.length} jobs',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Job Cards List
                if (filteredJobs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 54,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No matching jobs found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try adjusting your search query or filters',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredJobs.map((job) {
                    final isSaved = widget.savedJobIds.contains(job.id);
                    final hasApplied =
                        widget.submittedApplications.any((a) => a.jobId == job.id);
                    return JobCard(
                      job: job,
                      isSaved: isSaved,
                      onTap: () => _openJobDetails(job, isSaved, hasApplied),
                      onBookmarkToggle: () => widget.onToggleBookmark(job.id),
                      onApply: () => _openApplicationForm(job),
                    );
                  }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openJobDetails(Job job, bool isSaved, bool hasApplied) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(
          job: job,
          isSaved: isSaved,
          onBookmarkToggle: () => widget.onToggleBookmark(job.id),
          onApplicationSubmitted: widget.onApplicationSubmitted,
          hasAlreadyApplied: hasApplied,
        ),
      ),
    );
  }

  void _openApplicationForm(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationFormScreen(
          job: job,
          onSubmit: widget.onApplicationSubmitted,
        ),
      ),
    );
  }
}
