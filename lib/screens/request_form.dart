import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class RideRequestForm extends StatefulWidget {
  @override
  _RideRequestFormState createState() => _RideRequestFormState();
}

class _RideRequestFormState extends State<RideRequestForm> {
  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(); 
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _smokingHabit = "Allow"; // Default selection

  @override
  void initState() {
    super.initState();
    _checkUserSignIn(); // Authenticate the user when the widget initializes
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _timeController.text = selectedTime.format(context);
      });
    }
  }

  Future<void> _checkUserSignIn() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("User is already signed in: ${user.uid}");
  } else {
    print("No user is signed in. Redirecting to sign-in page...");
    // Navigate to your login/sign-up page.
  }
}

  void _savePickupLocation() async {
    if (_pickupLocationController.text.isNotEmpty) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Save to Firestore
          await FirebaseFirestore.instance.collection('ride_requests').add({
            'user_id': user.uid, // Link the request to the authenticated user
            'pickup_location': _pickupLocationController.text,
            'smoking_habit': _smokingHabit,
            'created_at': FieldValue.serverTimestamp(),
          });
          print('Pickup location saved successfully!');
        } else {
          print('User is not authenticated');
        }
      } catch (e) {
        print('Failed to save pickup location: $e');
      }
    } else {
      print('Pickup location cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures the layout adjusts to keyboard
      appBar: AppBar(
        title: const Text("Ride Request Form"),
      ),
      body: SingleChildScrollView( // Make the form scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Enter details for the ride request"),
              const SizedBox(height: 20),
              // Pickup Location Input Field
              TextField(
                controller: _pickupLocationController,
                decoration: const InputDecoration(labelText: "Pickup Location"),
              ),
              const SizedBox(height: 12),
              // Drop-off Location Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Drop-off Location"),
              ),
              const SizedBox(height: 12),
              // Date Input Field
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: "Date"),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Time Input Field
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(labelText: "Time"),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Reoccurrence Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Reoccurence"),
              ),
              const SizedBox(height: 12),
              // Driver Smoking Habits Input Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Driver Smoking Habits",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Allow"),
                          value: "Allow",
                          groupValue: _smokingHabit,
                          onChanged: (value) {
                            setState(() {
                              _smokingHabit = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Deny"),
                          value: "Deny",
                          groupValue: _smokingHabit,
                          onChanged: (value) {
                            setState(() {
                              _smokingHabit = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Price Input Field
              TextField(
                controller: _priceController, // Create a TextEditingController for the price input
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Limit to two decimal places
                ],
                decoration: const InputDecoration(
                  labelText: "Price",
                  prefixText: "RM ", // Adds "RM" in front of the input value
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                // Handle Ride Request submission
                onPressed: _savePickupLocation,
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
