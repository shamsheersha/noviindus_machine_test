import 'package:ayurved_care/providers/auth_provider.dart';
import 'package:ayurved_care/providers/patientlist_provider.dart';
import 'package:ayurved_care/screens/login_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      if (authProvider.isAuthenticated) {
        patientProvider.fetchPatientList(token: authProvider.token!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_active_rounded),
          ),
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await patientProvider.fetchPatientList(
                token: authProvider.token!,
              );
            },
            color: AppColors.primaryGreen,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: patientProvider.patientList.isEmpty
                  ? SizedBox(
                      height:
                          MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          kBottomNavigationBarHeight,
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
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: patientProvider.patientList.length,
                      itemBuilder: (context, index) {
                        final patient = patientProvider.patientList[index];
                        return Card(
                          child: ListTile(
                            title: Text(patient.name),
                            subtitle: Text(patient.phone),
                            trailing: Text(
                              patient.balanceAmount.toStringAsFixed(2),
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
            onPressed: () {
              // Handle Register action
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

  _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
