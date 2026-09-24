import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../models/job_data.dart';
import '../widgets/job_card.dart';
import 'job_details_screen.dart';
import 'application_form_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  final Set<String> savedJobIds;
  final Function(String) onToggleBookmark;
  final Function(JobApplication) onApplicationSubmitted;
  final List<JobApplication> submittedApplications;
  final Function(int) onNavigateToExplore;

  const SavedJobsScreen({
    super.key,
    required this.savedJobIds,
    required this.onToggleBookmark,
    required this.onApplicationSubmitted,
    required this.submittedApplications,
    required this.onNavigateToExplore,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final savedJobs = JobDummyData.allJobs.where((j) => savedJobIds.contains(j.id)).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: savedJobs.isEmpty
          ? _buildEmptyState(context, isDark)
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saved Opportunities',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'You have ${savedJobs.length} bookmarked position${savedJobs.length == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        if (savedJobs.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                  title: Text(
                                    'Clear Saved Jobs?',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to remove all saved jobs?',
                                    style: TextStyle(
                                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        for (final id in savedJobIds.toList()) {
                                          onToggleBookmark(id);
                                        }
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text(
                                        'Clear All',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Clear All', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...savedJobs.map((job) {
                      final hasApplied = submittedApplications.any((a) => a.jobId == job.id);
                      return JobCard(
                        job: job,
                        isSaved: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailsScreen(
                                job: job,
                                isSaved: true,
                                onBookmarkToggle: () => onToggleBookmark(job.id),
                                onApplicationSubmitted: onApplicationSubmitted,
                                hasAlreadyApplied: hasApplied,
                              ),
                            ),
                          );
                        },
                        onBookmarkToggle: () {
                          onToggleBookmark(job.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Removed "${job.title}" from saved jobs'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        onApply: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicationFormScreen(
                                job: job,
                                onSubmit: onApplicationSubmitted,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3A8A).withOpacity(0.3) : Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border_rounded,
                size: 64,
                color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Saved Jobs Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click the bookmark icon on any job card to save it for quick reference and future applications.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => onNavigateToExplore(0),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore Job Listings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
