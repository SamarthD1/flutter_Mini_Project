import 'package:flutter/material.dart';

class JobCategory {
  final String id;
  final String title;
  final IconData icon;
  final int jobsCount;
  final Color themeColor;

  const JobCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.jobsCount,
    required this.themeColor,
  });
}

class Job {
  final String id;
  final String title;
  final String company;
  final String companyLogoUrl;
  final String location;
  final String categoryId;
  final String salary;
  final String jobType; // Full Time, Part Time, Contract, Internship
  final String workplaceType; // Remote, On-site, Hybrid
  final String experienceLevel; // Entry, Mid, Senior, Lead
  final String postedAgo;
  final String description;
  final List<String> responsibilities;
  final List<String> requirements;
  final List<String> benefits;
  final List<String> skills;
  final bool isFeatured;
  final Color cardColor;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.companyLogoUrl,
    required this.location,
    required this.categoryId,
    required this.salary,
    required this.jobType,
    required this.workplaceType,
    required this.experienceLevel,
    required this.postedAgo,
    required this.description,
    required this.responsibilities,
    required this.requirements,
    required this.benefits,
    required this.skills,
    this.isFeatured = false,
    this.cardColor = const Color(0xFF2563EB),
  });
}

class JobApplication {
  final String id;
  final String jobId;
  final String jobTitle;
  final String company;
  final String applicantName;
  final String email;
  final String phone;
  final String portfolioUrl;
  final String experienceLevel;
  final String educationLevel;
  final String workPreference; // Remote, Hybrid, On-site
  final bool immediatelyAvailable;
  final bool willingToRelocate;
  final bool subscribeAlerts;
  final List<String> selectedSkills;
  final String coverLetter;
  final DateTime appliedAt;
  final String status; // Submitted, Under Review, Shortlisted

  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.portfolioUrl,
    required this.experienceLevel,
    required this.educationLevel,
    required this.workPreference,
    required this.immediatelyAvailable,
    required this.willingToRelocate,
    required this.subscribeAlerts,
    required this.selectedSkills,
    required this.coverLetter,
    required this.appliedAt,
    this.status = 'Submitted',
  });
}
