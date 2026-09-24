import 'package:flutter/material.dart';
import '../models/job_model.dart';

class ApplicationFormScreen extends StatefulWidget {
  final Job job;
  final Function(JobApplication) onSubmit;

  const ApplicationFormScreen({
    super.key,
    required this.job,
    required this.onSubmit,
  });

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameController = TextEditingController(text: 'Raju P');
  final _emailController = TextEditingController(text: 'raju.p@example.com');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _portfolioController = TextEditingController(text: 'https://github.com/RajuP');
  final _coverNoteController = TextEditingController(
    text: 'I am excited about this opportunity and believe my skill set matches the role perfectly.',
  );

  // Dropdown values
  String _selectedExperience = '3-5 years';
  String _selectedEducation = 'Bachelor Degree';

  // Radio value
  String _selectedWorkPreference = 'Remote';

  // Switch values
  bool _isImmediatelyAvailable = true;
  bool _subscribeAlerts = true;

  // Checkbox values
  bool _willingToRelocate = false;
  bool _agreedToTerms = false;
  final Map<String, bool> _selectedSkills = {};

  final List<String> _experienceOptions = [
    'Entry Level (0-1 yr)',
    '1-3 years',
    '3-5 years',
    '5-8 years',
    '8+ years',
  ];

  final List<String> _educationOptions = [
    'High School / Diploma',
    'Bachelor Degree',
    'Master Degree',
    'Doctorate / PhD',
  ];

  final List<String> _workPreferences = ['Remote', 'Hybrid', 'On-site'];

  @override
  void initState() {
    super.initState();
    // Initialize skill checkboxes based on job requirements
    for (final skill in widget.job.skills) {
      _selectedSkills[skill] = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
    _coverNoteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions to proceed.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Build the application object
    final selectedSkillsList = _selectedSkills.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final application = JobApplication(
      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
      jobId: widget.job.id,
      jobTitle: widget.job.title,
      company: widget.job.company,
      applicantName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      portfolioUrl: _portfolioController.text.trim(),
      experienceLevel: _selectedExperience,
      educationLevel: _selectedEducation,
      workPreference: _selectedWorkPreference,
      immediatelyAvailable: _isImmediatelyAvailable,
      willingToRelocate: _willingToRelocate,
      subscribeAlerts: _subscribeAlerts,
      selectedSkills: selectedSkillsList,
      coverLetter: _coverNoteController.text.trim(),
      appliedAt: DateTime.now(),
      status: 'Submitted',
    );

    // Show Confirmation AlertDialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 28),
              const SizedBox(width: 10),
              Text(
                'Confirm Submission',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to submit your application for ${widget.job.title} at ${widget.job.company}?',
                style: TextStyle(fontSize: 14, height: 1.4, color: isDark ? Colors.grey.shade300 : Colors.black87),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Applicant: ${_nameController.text.trim()}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 4),
                    Text('Email: ${_emailController.text.trim()}', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.black87)),
                    const SizedBox(height: 4),
                    Text('Preference: $_selectedWorkPreference', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Review Again', style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss dialog
                widget.onSubmit(application); // Notify parent callback

                // Show success SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.task_alt_rounded, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(child: Text('Application submitted for ${widget.job.title}!')),
                      ],
                    ),
                    backgroundColor: const Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                  ),
                );

                Navigator.of(context).pop(); // Return to previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Confirm & Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Job Application Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // Target Job Banner Card
                Card(
                  elevation: 0,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isDark ? const Color(0xFF334155) : Colors.blue.shade100,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.work_rounded,
                          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.job.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.job.company} • ${widget.job.location}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade400 : Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Section 1: Personal Details
                _buildSectionCard(
                  isDark: isDark,
                  title: 'Personal Information',
                  icon: Icons.person_outline_rounded,
                  children: [
                    // Full Name TextFormField
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'e.g. Raju Patel',
                        prefixIcon: Icon(Icons.person_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Email TextFormField
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address *',
                        hintText: 'raju.patel@example.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Phone TextFormField
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        hintText: '+91 98765 43210',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Portfolio / GitHub Link
                    TextFormField(
                      controller: _portfolioController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: const InputDecoration(
                        labelText: 'Portfolio / GitHub URL',
                        hintText: 'https://github.com/rajupatel',
                        prefixIcon: Icon(Icons.link_rounded),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Section 2: Experience & Education Dropdowns
                _buildSectionCard(
                  isDark: isDark,
                  title: 'Experience & Education',
                  icon: Icons.school_outlined,
                  children: [
                    // DropdownButtonFormField for Experience Level
                    DropdownButtonFormField<String>(
                      value: _selectedExperience,
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: 'Total Experience *',
                        prefixIcon: Icon(Icons.timeline_rounded),
                      ),
                      items: _experienceOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedExperience = newValue);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // DropdownButtonFormField for Education Level
                    DropdownButtonFormField<String>(
                      value: _selectedEducation,
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: 'Highest Education *',
                        prefixIcon: Icon(Icons.auto_stories_outlined),
                      ),
                      items: _educationOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedEducation = newValue);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Section 3: Work Preference (Radio Buttons)
                _buildSectionCard(
                  isDark: isDark,
                  title: 'Work Preference',
                  icon: Icons.apartment_outlined,
                  children: [
                    Text(
                      'Choose your preferred work mode:',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ..._workPreferences.map(
                      (mode) => RadioListTile<String>(
                        title: Text(
                          mode,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        value: mode,
                        groupValue: _selectedWorkPreference,
                        activeColor: const Color(0xFF2563EB),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() => _selectedWorkPreference = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Section 4: Skills Proficiency (Checkboxes)
                _buildSectionCard(
                  isDark: isDark,
                  title: 'Skill Proficiencies',
                  icon: Icons.verified_outlined,
                  children: [
                    Text(
                      'Select all relevant skills you have mastery in:',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.job.skills.map(
                      (skill) => CheckboxListTile(
                        title: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        value: _selectedSkills[skill] ?? false,
                        activeColor: const Color(0xFF2563EB),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedSkills[skill] = value ?? false;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Section 5: Availability & Preferences (Switches & Checkbox)
                _buildSectionCard(
                  isDark: isDark,
                  title: 'Availability & Notifications',
                  icon: Icons.tune_rounded,
                  children: [
                    // SwitchListTile for Immediate availability
                    SwitchListTile(
                      title: Text(
                        'Available for immediate start',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Can join within 1-2 weeks',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      value: _isImmediatelyAvailable,
                      activeColor: const Color(0xFF2563EB),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (bool value) {
                        setState(() => _isImmediatelyAvailable = value);
                      },
                    ),
                    Divider(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200),
                    // SwitchListTile for Alert subscriptions
                    SwitchListTile(
                      title: Text(
                        'Subscribe to application updates',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Receive real-time email & SMS status changes',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      value: _subscribeAlerts,
                      activeColor: const Color(0xFF2563EB),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (bool value) {
                        setState(() => _subscribeAlerts = value);
                      },
                    ),
                    Divider(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200),
                    // Checkbox for Relocation
                    CheckboxListTile(
                      title: Text(
                        'Willing to relocate if required',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      value: _willingToRelocate,
                      activeColor: const Color(0xFF2563EB),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? val) => setState(() => _willingToRelocate = val ?? false),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Section 6: Cover Letter Note (TextFormField)
                _buildSectionCard(
                  isDark: isDark,
                  title: 'Cover Note / Introduction',
                  icon: Icons.note_alt_outlined,
                  children: [
                    TextFormField(
                      controller: _coverNoteController,
                      maxLines: 4,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: const InputDecoration(
                        hintText: 'Briefly explain why you are a great fit for this role...',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Terms Agreement Checkbox
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CheckboxListTile(
                    title: Text(
                      'I agree to the Terms of Service, Privacy Policy, and declare that the provided information is true and accurate.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                      ),
                    ),
                    value: _agreedToTerms,
                    activeColor: const Color(0xFF2563EB),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? val) => setState(() => _agreedToTerms = val ?? false),
                  ),
                ),

                const SizedBox(height: 24),

                // Submit ElevatedButton
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Submit Application',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: isDark ? 1 : 1.5,
      shadowColor: Colors.black12,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}
