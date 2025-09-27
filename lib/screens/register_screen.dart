import 'dart:developer';

import 'package:ayurved_care/providers/branchlist_provider.dart';
import 'package:ayurved_care/providers/register_provider.dart';
import 'package:ayurved_care/providers/treatmentlist_provider.dart';
import 'package:ayurved_care/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ayurved_care/models/treatment_model.dart';

import 'package:ayurved_care/services/storage_service.dart';

class RegisterNowScreen extends StatefulWidget {
  const RegisterNowScreen({super.key});

  @override
  RegisterNowScreenState createState() => RegisterNowScreenState();
}

class RegisterNowScreenState extends State<RegisterNowScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _excecutiveController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _discountAmountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  final _balanceAmountController = TextEditingController();
  final _dateTimeController = TextEditingController();

  String? _selectedLocation;
  String? _selectedBranchId;
  String? _selectedPaymentOption;
  TreatmentModel? _selectedTreatment;
  int _maleCount = 0;
  int _femaleCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your full name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (!_validateName(value)) {
                      return 'Please enter a valid name (only letters and spaces)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Number
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Number',
                    hintText: 'Enter your 10-digit mobile number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!_validatePhone(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter your complete address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    if (!_validateAddress(value)) {
                      return 'Please enter a valid address (minimum 10 characters)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _excecutiveController,
                  decoration: InputDecoration(
                    labelText: 'Executive',
                    hintText: 'Enter executive name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter executive name';
                    }
                    if (!_validateName(value)) {
                      return 'Please enter a valid executive name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Location Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedLocation,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Calicut', 'Malappuram', 'Kochi', 'Trivandrum']
                      .map(
                        (location) => DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Branch Dropdown
                Consumer<BranchProvider>(
                  builder: (context, branchProvider, child) {
                    if (branchProvider.isFetchingBranches) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedBranchId,
                      decoration: InputDecoration(
                        labelText: 'Branch',
                        border: OutlineInputBorder(),
                      ),
                      items: branchProvider.branchList
                          .map(
                            (branch) => DropdownMenuItem(
                              value: branch.id.toString(),
                              child: Text(branch.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBranchId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a branch';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                // Treatments Section
                Row(
                  children: [
                    Text(
                      'Treatments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () => _showTreatmentPopup(context),
                      icon: Icon(
                        Icons.add,
                        color: AppColors.primaryGreen,
                      ),
                      label: Text(
                        'Add Treatments',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                if (_selectedTreatment != null)
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedTreatment!.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Text('Male: $_maleCount'),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Text('Female: $_femaleCount'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: Icon(Icons.delete,),
                            onPressed: () {
                              setState(() {
                                _selectedTreatment = null;
                                _maleCount = 0;
                                _femaleCount = 0;
                              });
                            },
                            tooltip: 'Remove Treatment',
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                // Total Amount
                TextFormField(
                  controller: _totalAmountController,
                  decoration: InputDecoration(
                    labelText: 'Total Amount',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Discount Amount
                TextFormField(
                  controller: _discountAmountController,
                  decoration: InputDecoration(
                    labelText: 'Discount Amount',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter discount amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 0) {
                      return 'Please enter a valid discount amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Payment Option
                Row(
                  children: [
                    Text(
                      'Payment Option',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16),
                    ChoiceChip(
                      label: Text('Cash'),
                      selected: _selectedPaymentOption == 'Cash',
                      onSelected: (selected) {
                        setState(() {
                          _selectedPaymentOption = 'Cash';
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('Card'),
                      selected: _selectedPaymentOption == 'Card',
                      onSelected: (selected) {
                        setState(() {
                          _selectedPaymentOption = 'Card';
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('UPI'),
                      selected: _selectedPaymentOption == 'UPI',
                      onSelected: (selected) {
                        setState(() {
                          _selectedPaymentOption = 'UPI';
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Advance Amount
                TextFormField(
                  controller: _advanceAmountController,
                  decoration: InputDecoration(
                    labelText: 'Advance Amount',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter advance amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 0) {
                      return 'Please enter a valid advance amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Balance Amount
                TextFormField(
                  controller: _balanceAmountController,
                  decoration: InputDecoration(
                    labelText: 'Balance Amount',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter balance amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 0) {
                      return 'Please enter a valid balance amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Treatment Date
                TextFormField(
                  controller: _dateTimeController,
                  decoration: InputDecoration(
                    labelText: 'Treatment Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.primaryGreen,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primaryGreen,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null) {
                        setState(() {
                          final formattedDate =
                              '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                          final formattedTime =
                              '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00';
                          _dateTimeController.text =
                              '$formattedDate $formattedTime';
                        });
                      }
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select treatment date and time';
                    }
                    if (!_validateDateTime(_dateTimeController.text)) {
                      return 'Please select a valid future date and time';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                // Save Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTreatmentPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Text(
                        'Choose Treatment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Treatment Selection
                      Consumer<TreatmentProvider>(
                        builder: (context, treatmentProvider, child) {
                          if (treatmentProvider.isFetchingTreatments) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              // Treatment Dropdown
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<TreatmentModel>(
                                    hint: Text(
                                      'Choose preferred treatment',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    value: _selectedTreatment,
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.primaryGreen,
                                    ),
                                    items: treatmentProvider.treatmentList
                                        .map(
                                          (treatment) => DropdownMenuItem(
                                            value: treatment,
                                            child: Text(
                                              treatment.name,
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setModalState(() {
                                        _selectedTreatment = value;
                                        _maleCount = 0;
                                        _femaleCount = 0;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              if (_selectedTreatment != null) ...[
                                SizedBox(height: 24),

                                // Add Patients Section
                                Text(
                                  'Add Patients',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Male Patients
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Male',
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.symmetric(
                                          vertical: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: _maleCount > 0
                                                  ? () {
                                                      setModalState(() {
                                                        _maleCount--;
                                                      });
                                                    }
                                                  : null,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.symmetric(
                                                vertical: BorderSide(
                                                  color: Colors.grey[300]!,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                _maleCount.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                setModalState(() {
                                                  _maleCount++;
                                                });
                                              },
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                // Female Patients
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Female',
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.symmetric(
                                          vertical: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: _femaleCount > 0
                                                  ? () {
                                                      setModalState(() {
                                                        _femaleCount--;
                                                      });
                                                    }
                                                  : null,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.symmetric(
                                                vertical: BorderSide(
                                                  color: Colors.grey[300]!,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                _femaleCount.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                setModalState(() {
                                                  _femaleCount++;
                                                });
                                              },
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 24),

                      // Save Button
                      Container(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _selectedTreatment != null
                              ? () {
                                  // Update the main screen state when closing
                                  setState(() {});
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Additional validation checks
      if (!_validateForm()) {
        return;
      }

      if (_selectedTreatment == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select a treatment')));
        return;
      }
      
      log('fffffffffffffSubmitting date: ${_dateTimeController.text}'); 
      if (_maleCount == 0 && _femaleCount == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please add at least one patient')),
        );
        return;
      }

      final token = await StorageService.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token not found. Please login again.')),
        );
        return;
      }

      final maleTreatmentIds = List.generate(
        _maleCount,
        (index) => _selectedTreatment!.id.toString(),
      );
      final femaleTreatmentIds = List.generate(
        _femaleCount,
        (index) => _selectedTreatment!.id.toString(),
      );

      final allTreatmentIds = [...maleTreatmentIds, ...femaleTreatmentIds];

      final result = await Provider.of<RegisterProvider>(context, listen: false)
          .registerPatient(
            token: token,
            name: _nameController.text,
            excecutive: _excecutiveController.text,
            payment: _selectedPaymentOption ?? 'Cash',
            phone: _phoneController.text,
            address: _addressController.text,
            totalAmount: double.tryParse(_totalAmountController.text) ?? 0.0,
            discountAmount:
                double.tryParse(_discountAmountController.text) ?? 0.0,
            advanceAmount:
                double.tryParse(_advanceAmountController.text) ?? 0.0,
            balanceAmount:
                double.tryParse(_balanceAmountController.text) ?? 0.0,
            dateNdTime: _dateTimeController.text,
            branch: _selectedBranchId ?? '',
            maleTreatmentIds: maleTreatmentIds,
            femaleTreatmentIds: femaleTreatmentIds,
            treatmentIds: allTreatmentIds,
          );

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient registered successfully!')),
        );
        Navigator.of(context).pop(true);
        // Clear form after successful registration
        _clearForm();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to register patient.')));
      }
    }
  }

  // Comprehensive validation method
  bool _validateForm() {
    // Validate name
    if (!_validateName(_nameController.text)) {
      _showValidationError('Please enter a valid name (only letters and spaces)');
      return false;
    }

    // Validate phone number
    if (!_validatePhone(_phoneController.text)) {
      _showValidationError('Please enter a valid 10-digit phone number');
      return false;
    }

    // Validate address
    if (!_validateAddress(_addressController.text)) {
      _showValidationError('Please enter a valid address (minimum 10 characters)');
      return false;
    }

    // Validate executive name
    if (!_validateName(_excecutiveController.text)) {
      _showValidationError('Please enter a valid executive name (only letters and spaces)');
      return false;
    }

    // Validate location
    if (_selectedLocation == null || _selectedLocation!.isEmpty) {
      _showValidationError('Please select a location');
      return false;
    }

    // Validate branch
    if (_selectedBranchId == null || _selectedBranchId!.isEmpty) {
      _showValidationError('Please select a branch');
      return false;
    }

    // Validate payment option
    if (_selectedPaymentOption == null || _selectedPaymentOption!.isEmpty) {
      _showValidationError('Please select a payment option');
      return false;
    }

    // Validate treatment
    if (_selectedTreatment == null) {
      _showValidationError('Please select a treatment');
      return false;
    }

    // Validate patient counts
    if (_maleCount == 0 && _femaleCount == 0) {
      _showValidationError('Please add at least one patient (male or female)');
      return false;
    }

    if (_maleCount < 0 || _femaleCount < 0) {
      _showValidationError('Patient count cannot be negative');
      return false;
    }

    if (_maleCount > 50 || _femaleCount > 50) {
      _showValidationError('Maximum 50 patients per gender allowed');
      return false;
    }

    // Validate amounts
    if (!_validateAmounts()) {
      return false;
    }

    // Validate date and time
    if (!_validateDateTime(_dateTimeController.text)) {
      _showValidationError('Please select a valid future date and time');
      return false;
    }

    return true;
  }

  // Name validation (only letters and spaces, 2-50 characters)
  bool _validateName(String name) {
    if (name.isEmpty) return false;
    if (name.length < 2 || name.length > 50) return false;
    
    // Check if name contains only letters, spaces, and common name characters
    final nameRegex = RegExp(r"^[a-zA-Z\s\.\-']+$");
    return nameRegex.hasMatch(name.trim());
  }

  // Phone validation (10-digit Indian mobile number)
  bool _validatePhone(String phone) {
    if (phone.isEmpty) return false;
    
    // Remove any spaces, dashes, or parentheses
    String cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check if it's exactly 10 digits
    if (cleanPhone.length != 10) return false;
    
    // Check if all characters are digits
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(cleanPhone)) return false;
    
    // Check if it starts with valid Indian mobile prefixes
    final validPrefixes = ['6', '7', '8', '9'];
    return validPrefixes.contains(cleanPhone[0]);
  }

  // Address validation (minimum 10 characters, not just spaces)
  bool _validateAddress(String address) {
    if (address.isEmpty) return false;
    if (address.trim().length < 10) return false;
    
    // Check if address contains meaningful content (not just special characters)
    final meaningfulChars = address.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return meaningfulChars.length >= 5;
  }

  // Amount validation
  bool _validateAmounts() {
    final totalAmount = double.tryParse(_totalAmountController.text);
    final discountAmount = double.tryParse(_discountAmountController.text);
    final advanceAmount = double.tryParse(_advanceAmountController.text);
    final balanceAmount = double.tryParse(_balanceAmountController.text);

    // Check if all amounts are valid numbers
    if (totalAmount == null || totalAmount < 0) {
      _showValidationError('Please enter a valid total amount (must be 0 or greater)');
      return false;
    }

    if (discountAmount == null || discountAmount < 0) {
      _showValidationError('Please enter a valid discount amount (must be 0 or greater)');
      return false;
    }

    if (advanceAmount == null || advanceAmount < 0) {
      _showValidationError('Please enter a valid advance amount (must be 0 or greater)');
      return false;
    }

    if (balanceAmount == null || balanceAmount < 0) {
      _showValidationError('Please enter a valid balance amount (must be 0 or greater)');
      return false;
    }

    // Check if discount is not more than total amount
    if (discountAmount > totalAmount) {
      _showValidationError('Discount amount cannot be greater than total amount');
      return false;
    }

    // Check if advance is not more than total amount
    if (advanceAmount > totalAmount) {
      _showValidationError('Advance amount cannot be greater than total amount');
      return false;
    }

    // Check if advance + discount is not more than total amount
    if ((advanceAmount + discountAmount) > totalAmount) {
      _showValidationError('Advance and discount combined cannot be greater than total amount');
      return false;
    }

    // Check if balance calculation is correct
    final calculatedBalance = totalAmount - discountAmount - advanceAmount;
    if ((balanceAmount - calculatedBalance).abs() > 0.01) { // Allow small floating point differences
      _showValidationError('Balance amount does not match calculated value (Total - Discount - Advance)');
      return false;
    }

    // Check reasonable amount limits
    if (totalAmount > 1000000) {
      _showValidationError('Total amount cannot exceed ₹10,00,000');
      return false;
    }

    return true;
  }

  // Date and time validation
  bool _validateDateTime(String dateTimeString) {
    if (dateTimeString.isEmpty) return false;
    
    try {
      // Parse the date time string
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      
      // Check if date is in the future
      if (dateTime.isBefore(now)) {
        return false;
      }
      
      // Check if date is not too far in the future (within 1 year)
      final oneYearFromNow = now.add(Duration(days: 365));
      if (dateTime.isAfter(oneYearFromNow)) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Helper method to show validation errors
  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _excecutiveController.clear();
    _phoneController.clear();
    _addressController.clear();
    _totalAmountController.clear();
    _discountAmountController.clear();
    _advanceAmountController.clear();
    _balanceAmountController.clear();
    _dateTimeController.clear();
    setState(() {
      _selectedLocation = null;
      _selectedBranchId = null;
      _selectedPaymentOption = null;
      _selectedTreatment = null;
      _maleCount = 0;
      _femaleCount = 0;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _excecutiveController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _totalAmountController.dispose();
    _discountAmountController.dispose();
    _advanceAmountController.dispose();
    _balanceAmountController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }
}
