import 'package:login_project_test1/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:login_project_test1/authentication/pages/registerpage.dart';

class PaymentPage extends StatefulWidget {
  final String expertName;
  final double expertPrice;
  final String bookingDate;
  final String bookingTime;

  PaymentPage({
    required this.expertName,
    required this.expertPrice,
    required this.bookingDate,
    required this.bookingTime,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  void _showPaymentDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Confirmation'),
            content: Text('Are you sure you want to proceed with payment?'),
            actions: [
              TextButton(
                onPressed: () {
                  // Perform payment logic here
                  _updateBookingStatus();
                  updateBookingCountForUser('id');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => HomePage(
                                isDarkModeEnabled: false,
                                toggleDarkMode: (bool) {},
                              )))); // Close the dialog
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  void _updateBookingStatus() async {
    // Get a reference to the booking document using its unique ID
    final bookingDocRef = FirebaseFirestore.instance
        .collection('booking')
        .where('date', isEqualTo: widget.bookingDate)
        .where('time', isEqualTo: widget.bookingTime);

    bookingDocRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Update the 'isBooked' field to true
        doc.reference.update({'isBooked': true});
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Payment is successful'),
        duration: Duration(seconds: 5), // You can adjust the duration as needed
      ),
    );
  }

  Future<void> updateBookingCountForUser(id) async {
    try {
      // Get a reference to the user document using its unique ID
      final userDocRef = FirebaseFirestore.instance
          .collection('user')
          .doc('pU2qR8WvppULbwnnuenj9DaLS6q2');

      // Retrieve the user document
      DocumentSnapshot userSnapshot = await userDocRef.get();

      // Check if the user document exists
      if (userSnapshot.exists) {
        // Get the current bookingCount value
        int currentBookingCount =
            (userSnapshot.data() as Map<String, dynamic>?)?['bookingCount'] ??
                0;

        int newBookingCount;

        if (currentBookingCount >= 5) {
          newBookingCount = 0;
        } else {
          // Increment the bookingCount by 1
          newBookingCount = currentBookingCount + 1;
        }
        // Update the 'bookingCount' field in the user document with the new value
        await userDocRef.update({'bookingCount': newBookingCount});

        print('BookingCount updated successfully for User ID: $id');
      } else {
        // Handle the case when the user document doesn't exist
        print('User ID: $id does not exist in the Firestore collection.');
      }
    } catch (e) {
      // Handle any errors that may occur during the process
      print('Error updating bookingCount: $e');
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Image.asset(
              'assets/images/logo.png', // Replace 'payment_logo.png' with your image path
              height: 170, // Customize the height as needed
              width: 170, // Make the image as wide as the screen
              fit: BoxFit
                  .cover, // Adjust the image's aspect ratio to cover the entire space
            ),
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.date_range,
                                    color: Colors.black,
                                  ),
                                  minLeadingWidth: -1,
                                  title: Text('${widget.bookingDate}'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.access_time_sharp,
                                    color: Colors.black,
                                  ),
                                  minLeadingWidth: -1,
                                  title: Text('${widget.bookingTime}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 19,
                  top: -2,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      'Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
'Expert Name: ${widget.expertName}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Expert Price: RM ${widget.expertPrice}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 19,
                  top: -2,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: 300,
                  height: 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Please check the details before paying',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentDialog(
                      context); // Show the payment dialog when pressed
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  minimumSize: Size(double.infinity, 0),
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}