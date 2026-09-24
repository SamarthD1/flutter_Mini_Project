import 'package:flutter/material.dart';
import '../models/job_model.dart';

class ApplicationsScreen extends StatelessWidget {
  final List<JobApplication> applications;
  final Function(int) onNavigateToExplore;

  const ApplicationsScreen({
    super.key,
    required this.applications,
    required this.onNavigateToExplore,
  });

  void _showApplicationDetails(BuildContext context, JobApplication app) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF2563EB)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                app.jobTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Company: ${app.company}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text('Applicant: ${app.applicantName}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              Text('Email: ${app.email}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              Text('Phone: ${app.phone}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              if (app.portfolioUrl.isNotEmpty)
                Text('Portfolio: ${app.portfolioUrl}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              const SizedBox(height: 8),
              Divider(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200),
              const SizedBox(height: 4),
              Text('Experience: ${app.experienceLevel}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              Text('Education: ${app.educationLevel}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              Text('Work Mode: ${app.workPreference}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              Text('Immediate Start: ${app.immediatelyAvailable ? "Yes" : "No"}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              Text('Relocation: ${app.willingToRelocate ? "Yes" : "No"}', style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87)),
              const SizedBox(height: 8),
              if (app.selectedSkills.isNotEmpty) ...[
                Text(
                  'Skills:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: app.selectedSkills
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E3A8A) : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
              ],
              if (app.coverLetter.isNotEmpty) ...[
                Text(
                  'Cover Note:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  app.coverLetter,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: applications.isEmpty
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
                              'Submitted Applications',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Track the status of your ${applications.length} submitted job applications',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...applications.reversed.map((app) {
                      return Card(
                        elevation: isDark ? 1 : 2,
                        shadowColor: Colors.black12,
                        margin: const EdgeInsets.only(bottom: 14),
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _showApplicationDetails(context, app),
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E3A8A).withOpacity(0.4) : const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.description_rounded,
                                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            app.jobTitle,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            app.company,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _buildStatusBadge(app.status, isDark),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Divider(
                                  height: 1,
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_rounded,
                                          size: 13,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Applied on ${_formatDate(app.appliedAt)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'View Details',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? const Color(0xFF60A5FA) : Colors.blue.shade700,
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 16,
                                          color: isDark ? const Color(0xFF60A5FA) : Colors.blue.shade700,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color bg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
    Color text = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);

    if (status == 'Under Review') {
      bg = isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7);
      text = isDark ? const Color(0xFFFDE68A) : const Color(0xFFB45309);
    } else if (status == 'Shortlisted') {
      bg = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
      text = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
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
                color: isDark ? const Color(0xFF064E3B).withOpacity(0.3) : Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_turned_in_outlined,
                size: 64,
                color: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Applications Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you apply for jobs using the application form, your submissions and their review status will appear here.',
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
              icon: const Icon(Icons.search_rounded),
              label: const Text('Browse Open Roles'),
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
