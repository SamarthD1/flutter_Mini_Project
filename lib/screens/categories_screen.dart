import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../models/job_data.dart';
import '../widgets/category_card.dart';
import '../widgets/job_card.dart';
import 'job_details_screen.dart';
import 'application_form_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final Set<String> savedJobIds;
  final Function(String) onToggleBookmark;
  final Function(JobApplication) onApplicationSubmitted;
  final List<JobApplication> submittedApplications;
  final String? initialSelectedCategoryId;

  const CategoriesScreen({
    super.key,
    required this.savedJobIds,
    required this.onToggleBookmark,
    required this.onApplicationSubmitted,
    required this.submittedApplications,
    this.initialSelectedCategoryId,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialSelectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredJobs = _selectedCategoryId == null
        ? JobDummyData.allJobs
        : JobDummyData.allJobs.where((j) => j.categoryId == _selectedCategoryId).toList();

    final selectedCategoryObj = _selectedCategoryId == null
        ? null
        : JobDummyData.categories.firstWhere(
            (c) => c.id == _selectedCategoryId,
            orElse: () => JobDummyData.categories.first,
          );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            children: [
              // Header section
              Text(
                'Explore Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Discover opportunities across high-demand industry sectors',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 18),

              // Categories Responsive GridView
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: JobDummyData.categories.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  mainAxisExtent: 140,
                ),
                itemBuilder: (context, index) {
                  final category = JobDummyData.categories[index];
                  final isSelected = category.id == _selectedCategoryId;
                  return CategoryCard(
                    category: category,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (_selectedCategoryId == category.id) {
                          _selectedCategoryId = null; // Toggle off filter
                        } else {
                          _selectedCategoryId = category.id;
                        }
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Filter Header & Reset Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        selectedCategoryObj != null
                            ? '${selectedCategoryObj.title} Jobs'
                            : 'All Open Positions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E3A8A) : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${filteredJobs.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedCategoryId != null)
                    TextButton.icon(
                      onPressed: () => setState(() => _selectedCategoryId = null),
                      icon: Icon(
                        Icons.clear_all_rounded,
                        size: 18,
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                      ),
                      label: Text(
                        'Show All',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 14),

              // List of Jobs in selected Category
              if (filteredJobs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_off_outlined,
                        size: 48,
                        color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No jobs found for this category',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredJobs.map((job) {
                  final isSaved = widget.savedJobIds.contains(job.id);
                  final hasApplied = widget.submittedApplications.any((a) => a.jobId == job.id);
                  return JobCard(
                    job: job,
                    isSaved: isSaved,
                    onTap: () {
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
                    },
                    onBookmarkToggle: () => widget.onToggleBookmark(job.id),
                    onApply: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationFormScreen(
                            job: job,
                            onSubmit: widget.onApplicationSubmitted,
                          ),
                        ),
                      );
                    },
                  );
                }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
