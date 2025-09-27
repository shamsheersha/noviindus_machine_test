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
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Number
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Number',
                    hintText: 'Enter your number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Whatsapp number';
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
                    hintText: 'Enter your full address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
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
                      icon: Icon(Icons.add),
                      label: Text('Add Treatments'),
                    ),
                  ],
                ),
                if (_selectedTreatment != null)
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
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
                            icon: Icon(Icons.delete, color: Colors.red),
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
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total amount';
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
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter discount amount';
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
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter advance amount';
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
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter balance amount';
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
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
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
                    return null;
                  },
                ),
                SizedBox(height: 24),
                // Save Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
                                      color: Colors.green,
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
                                              color: Colors.green,
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
                                              color: Colors.green,
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
                                              color: Colors.green,
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
                                              color: Colors.green,
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
