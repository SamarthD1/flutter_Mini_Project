import 'package:flutter/material.dart';
import '../models/job_model.dart';
import 'application_form_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;
  final bool isSaved;
  final VoidCallback onBookmarkToggle;
  final Function(JobApplication) onApplicationSubmitted;
  final bool hasAlreadyApplied;

  const JobDetailsScreen({
    super.key,
    required this.job,
    required this.isSaved,
    required this.onBookmarkToggle,
    required this.onApplicationSubmitted,
    this.hasAlreadyApplied = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Job Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved
                  ? const Color(0xFF3B82F6)
                  : (isDark ? Colors.white70 : Colors.grey.shade700),
            ),
            onPressed: onBookmarkToggle,
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: isDark ? Colors.white70 : Colors.grey.shade700),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Job link copied for ${job.title}!'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Scrollable Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  children: [
                    // Header Card with Company Logo, Title, Location & Salary
                    Card(
                      elevation: isDark ? 1 : 2,
                      shadowColor: Colors.black12,
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isDark ? const Color(0xFF334155) : Colors.transparent,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF334155) : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF475569) : Colors.grey.shade200,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  job.companyLogoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Icon(
                                    Icons.business_rounded,
                                    size: 40,
                                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              job.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              job.company,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFF60A5FA) : Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  job.location,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.currency_rupee_rounded,
                                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    job.salary,
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Key Info Badges Grid
                    Row(
                      children: [
                        _buildInfoBadge('Workplace', job.workplaceType, Icons.home_work_outlined, isDark),
                        const SizedBox(width: 10),
                        _buildInfoBadge('Job Type', job.jobType, Icons.work_history_outlined, isDark),
                        const SizedBox(width: 10),
                        _buildInfoBadge('Level', job.experienceLevel.split(' ')[0], Icons.trending_up_rounded, isDark),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Required Skills
                    _buildSectionHeader('Required Skills', Icons.psychology_outlined, isDark),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.skills
                          .map(
                            (skill) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.grey.shade200 : const Color(0xFF334155),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 22),

                    // Job Description
                    _buildSectionHeader('About The Role', Icons.description_outlined, isDark),
                    const SizedBox(height: 8),
                    Text(
                      job.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Responsibilities
                    _buildSectionHeader('Key Responsibilities', Icons.checklist_rounded, isDark),
                    const SizedBox(height: 10),
                    ...job.responsibilities.map((item) => _buildBulletPoint(item, isDark: isDark)),

                    const SizedBox(height: 22),

                    // Qualifications / Requirements
                    _buildSectionHeader('Qualifications & Skills', Icons.school_outlined, isDark),
                    const SizedBox(height: 10),
                    ...job.requirements.map((item) => _buildBulletPoint(item, isDark: isDark)),

                    const SizedBox(height: 22),

                    // Benefits & Perks
                    _buildSectionHeader('Benefits & Perks', Icons.card_giftcard_rounded, isDark),
                    const SizedBox(height: 10),
                    ...job.benefits.map(
                      (item) => _buildBulletPoint(
                        item,
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Bottom Fixed Action Bar with ElevatedButton
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? const Color(0xFF475569) : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: isSaved
                                ? const Color(0xFF3B82F6)
                                : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                          ),
                          onPressed: onBookmarkToggle,
                          tooltip: isSaved ? 'Saved' : 'Save Job',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: hasAlreadyApplied
                              ? null
                              : () {
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                isDark ? const Color(0xFF334155) : Colors.grey.shade400,
                            disabledForegroundColor:
                                isDark ? Colors.grey.shade500 : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            hasAlreadyApplied ? 'Applied Already' : 'Apply For This Position',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge(String label, String value, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(
    String text, {
    IconData icon = Icons.circle,
    Color iconColor = const Color(0xFF2563EB),
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(icon, size: icon == Icons.circle ? 6 : 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
