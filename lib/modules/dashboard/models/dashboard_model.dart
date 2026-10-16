class DashboardModel {
  final int mandateCount;
  final int kycCount;
  final int joiningCount;
  final int payrollCount;
  final List<JobModel> jobs;

  DashboardModel({
    required this.mandateCount,
    required this.kycCount,
    required this.joiningCount,
    required this.payrollCount,
    required this.jobs,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['Data'] ?? {});

    final mandateDetails = data['MandateDetails'];

    return DashboardModel(
      mandateCount: _toInt(data['MandateCount']),
      kycCount: _toInt(data['KycCount']),
      joiningCount: _toInt(data['JoiningCount']),
      payrollCount: _toInt(data['PayrollCount']),
      jobs: mandateDetails is List
          ? mandateDetails
                .map(
                  (item) => JobModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : [],
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    return int.tryParse(value.toString()) ?? 0;
  }
}

class JobModel {
  final int mandateId;
  final String title;
  final String clientName;
  final String location;
  final int vacancies;
  final int selected;
  final String department;
  final String recruiterName;
  final String branchName;
  final String positionDescription;
  final String qualification;
  final dynamic minExperience;
  final dynamic maxExperience;
  final dynamic minAge;
  final dynamic maxAge;
  final dynamic minCTC;
  final String recruitmentType;
  final String mandateSkill;

  JobModel({
    required this.mandateId,
    required this.title,
    required this.clientName,
    required this.location,
    required this.vacancies,
    required this.selected,
    required this.department,
    required this.recruiterName,
    required this.branchName,
    required this.positionDescription,
    required this.qualification,
    required this.minExperience,
    required this.maxExperience,
    required this.minAge,
    required this.maxAge,
    required this.minCTC,
    required this.recruitmentType,
    required this.mandateSkill,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    final mandateSkill = json['MandateSkill']?.toString().trim() ?? '';

    final recruitmentType = json['RecruitmentType']?.toString() ?? '';

    final department = mandateSkill.isEmpty || mandateSkill == '.'
        ? recruitmentType
        : '$mandateSkill | $recruitmentType';

    return JobModel(
      mandateId: _toInt(json['MandateId']),
      title: json['PositionName']?.toString() ?? '',
      clientName: json['ClientName']?.toString() ?? '',
      location: json['PositionLocation']?.toString() ?? '',
      vacancies: _toInt(json['PositionNumber']),
      selected: _toInt(json['JoiningCount']),
      department: department,
      recruiterName: json['RecruiterName']?.toString() ?? '',
      branchName: json['BranchName']?.toString() ?? '',
      positionDescription: json['PositionDescription']?.toString() ?? '',
      qualification: json['Qualification']?.toString() ?? '',
      minExperience: json['MinExperience'],
      maxExperience: json['MaxExperience'],
      minAge: json['MinAge'],
      maxAge: json['MaxAge'],
      minCTC: json['MinCTC'],
      recruitmentType: recruitmentType,
      mandateSkill: mandateSkill,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
