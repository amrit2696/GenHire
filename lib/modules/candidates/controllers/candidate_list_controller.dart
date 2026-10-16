import 'package:get/get.dart';
import '../models/candidate_model.dart';

class CandidateListController extends GetxController {
  final searchController = ''.obs;
  final selectedFilter = 'All'.obs;

  final RxList<CandidateModel> candidates = <CandidateModel>[
    const CandidateModel(
      id: 1,
      name: 'Sovan Sharma',
      email: 'sovan.sharma@example.com',
      phone: '9876543210',
      experience: '3.7 years',
      status: 'Approved',
      aadhaarNumber: '1234 5678 9012',
      ssoId: 'SSO12345',
      position: 'Flutter Developer',
      location: 'Kolkata, West Bengal',
      recruiterName: 'Amrit',
    ),
    const CandidateModel(
      id: 2,
      name: 'Rahul Das',
      email: 'rahul.das@example.com',
      phone: '9876543211',
      experience: '2.5 years',
      status: 'Not-Join',
      aadhaarNumber: '2345 6789 0123',
      ssoId: 'SSO23456',
      position: 'Software Developer',
      location: 'Howrah, West Bengal',
      recruiterName: 'Amrit',
    ),
    const CandidateModel(
      id: 3,
      name: 'Priya Singh',
      email: 'priya.singh@example.com',
      phone: '9876543212',
      experience: '4.0 years',
      status: 'Approved',
      aadhaarNumber: '3456 7890 1234',
      ssoId: 'SSO34567',
      position: 'Senior Flutter Developer',
      location: 'Kolkata, West Bengal',
      recruiterName: 'Amrit',
    ),
    const CandidateModel(
      id: 4,
      name: 'Arjun Roy',
      email: 'arjun.roy@example.com',
      phone: '9876543213',
      experience: '1.5 years',
      status: 'Not-Join',
      aadhaarNumber: '4567 8901 2345',
      ssoId: 'SSO45678',
      position: 'Mobile App Developer',
      location: 'Durgapur, West Bengal',
      recruiterName: 'Amrit',
    ),
  ].obs;

  List<CandidateModel> get filteredCandidates {
    final query = searchController.value.trim().toLowerCase();

    return candidates.where((candidate) {
      final matchesSearch =
          candidate.name.toLowerCase().contains(query) ||
          candidate.email.toLowerCase().contains(query) ||
          candidate.phone.contains(query);

      final matchesStatus =
          selectedFilter.value == 'All' ||
          candidate.status == selectedFilter.value;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  int get approvedCount =>
      candidates.where((candidate) => candidate.status == 'Approved').length;

  int get notJoinedCount =>
      candidates.where((candidate) => candidate.status == 'Not-Join').length;

  void searchCandidates(String value) {
    searchController.value = value;
  }

  void filterCandidates(String value) {
    selectedFilter.value = value;
  }
}
