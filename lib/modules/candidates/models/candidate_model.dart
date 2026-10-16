class CandidateModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String experience;
  final String status;
  final String aadhaarNumber;
  final String ssoId;
  final String position;
  final String location;
  final String recruiterName;

  const CandidateModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.experience,
    required this.status,
    required this.aadhaarNumber,
    required this.ssoId,
    required this.position,
    required this.location,
    required this.recruiterName,
  });
}
