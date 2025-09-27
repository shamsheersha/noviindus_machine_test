import 'package:ayurved_care/providers/auth_provider.dart';
import 'package:ayurved_care/providers/branchlist_provider.dart';
import 'package:ayurved_care/providers/patientlist_provider.dart';
import 'package:ayurved_care/providers/treatmentlist_provider.dart';
import 'package:ayurved_care/screens/login_screen.dart';
import 'package:ayurved_care/screens/register_screen.dart';
import 'package:ayurved_care/services/storage_service.dart';
import 'package:ayurved_care/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    final token = await StorageService.getToken();
    if (token != null) {
      await Future.wait([
        _fetchPatientData(token),
        _fetchBranchData(token),
        _fetchTreatmentData(token),
      ]);
    }
  }

  Future<void> _fetchPatientData(String token) async {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    await patientProvider.fetchPatientList(token: token);
  }

  Future<void> _fetchBranchData(String token) async {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    await branchProvider.fetchBranchList(token: token);
  }

  Future<void> _fetchTreatmentData(String token) async {
    final treatmentProvider = Provider.of<TreatmentProvider>(context, listen: false);
    await treatmentProvider.fetchTreatmentList(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurveda Care'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_rounded),
          ),
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          if (patientProvider.isFetchingPatients && patientProvider.patientList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }

          if (patientProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                patientProvider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (patientProvider.patientList.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No patients found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await patientProvider.fetchPatientList(token: authProvider.token!);
            },
            color: AppColors.primaryGreen,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patientProvider.patientList.length > 100 ? 100 : patientProvider.patientList.length,
                itemBuilder: (context, index) {
                  final patient = patientProvider.patientList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 3,
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${index + 1}.',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    patient.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (patient.treatments.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  patient.treatments.join(', '),
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(patient.dateAndTime),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  patient.excecutive.isNotEmpty ? patient.excecutive : 'N/A',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('View details for ${patient.name}')),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View Booking Details',
                                      style: TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.primaryGreen,
                                      size: 16,
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
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FloatingActionButton.extended(
            backgroundColor: AppColors.primaryGreen,
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => const RegisterNowScreen(),
                ),
              );
              if (result == true) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final patientProvider = Provider.of<PatientProvider>(context, listen: false);
                if (authProvider.isAuthenticated) {
                  await patientProvider.fetchPatientList(token: authProvider.token!);
                }
              }
            },
            label: const Text(
              "Register Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'No date set';
    }
    try {
      if (dateString.contains('T')) {
        final dateTime = DateTime.parse(dateString.split('.').first);
        return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
      } else if (dateString.contains(' ')) {
        final dateTime = DateTime.parse(dateString.replaceAll(' ', 'T'));
        return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
      } else if (dateString.contains('/')) {
        return dateString;
      } else if (dateString.contains('-')) {
        final dateTime = DateTime.parse(dateString);
        return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
      } else {
        return dateString;
      }
    } catch (e) {
      return dateString;
    }
  }
}
