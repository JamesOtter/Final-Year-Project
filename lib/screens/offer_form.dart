import 'package:flutter/material.dart';

class RideOfferForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures the layout adjusts to keyboard
      appBar: AppBar(
        title: Text("Ride Request Form"),
      ),
      body: SingleChildScrollView( // Make the form scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Enter details for the ride request"),
              const SizedBox(height: 20),
              // Pickup Location Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Pickup Location"),
              ),
              const SizedBox(height: 12),
              // Drop-off Location Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Drop-off Location"),
              ),
              const SizedBox(height: 12),
              // Date Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Date"),
              ),
              const SizedBox(height: 12),
              // Time Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Time"),
              ),
              const SizedBox(height: 12),
              // Reoccurrence Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Reoccurence"),
              ),
              const SizedBox(height: 12),
              // Driver Smoking Habits Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Driver Smoking Habits"),
              ),
              const SizedBox(height: 12),
              // Price Input Field
              const TextField(
                decoration: InputDecoration(labelText: "Price"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle Ride Request submission
                },
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}