import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';//url
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String phoneNumber = '0';
  final List<String> categories = [
    'Aircond Maintenance',
    'Car Washing',
    'House Cleaning',
    'Lawn Maintenance',
    'House Disinfection',
    'House Painting',
  ];

  /*final List<String> categoryImageAssets = [
    'assets/images/aircond.png',
    'assets/images/carwash.png',
    'assets/images/houseclean.png',
    'assets/images/lawn.png',
    'assets/images/house_dis.png',
    'assets/images/housepaint.png',
  ];*/

  final List<Color> categoryColors = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
  ];

  List<String> cartItems = [];
  double _bookingCount = 0;
  final double _totalBooking = 5; // Set the progress value between 0.0 and 1.0 // List of items in the cart

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Function to show the custom dialog
  void showCustomDialog(BuildContext context) {
    YYDialog().build(context)
      ..width = 300
      ..borderRadius = 20.0
      ..barrierDismissible = true
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      }
      ..widget(
        Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/image/car_wash.gif', // Replace with your own GIF path
                width: 200,
                height: 200,
              ),
              //SizedBox(height: 5),
              Text(
                'FREE NANO CAR WASH',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Valid for 5 bookings per month',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Claim Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      )
      ..show();
  }

  Future<void> retrieveUserData() async {
  try {
    // Get the current user's ID (assuming the user is authenticated)
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // Get a reference to the user's document in Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (userSnapshot.exists) {
        // Access the data in the user's document using the userSnapshot.data() method
        Map<String, dynamic> userData = userSnapshot.data()!;

        // Get the bookingCount value from the userData map and cast it to double
        double bookingCount = (userData['bookingCount'] as num?)?.toDouble() ?? 0.0;

        // Update the _bookingCount variable
        setState(() {
          _bookingCount = bookingCount;
        });
      }
    }
  } catch (e) {
    print('Error retrieving user data: $e');
  }
}

Future<String?> retrievePhoneNumber(String EID) async {
  try {
    // Get the reference to the expert document using the expertId
    DocumentSnapshot<Map<String, dynamic>> expertsSnapshot =
        await FirebaseFirestore.instance.collection('experts').doc('Hani').get();

        print('Expert Snapshot: ${expertsSnapshot.data()}');
        //print('Expert Data: $expertsData');


    // Check if the document exists
    if (expertsSnapshot.exists) {
      // Access the data in the expert document using the expertSnapshot.data() method
      Map<String, dynamic> expertsData = expertsSnapshot.data()!;
      
      // Get the phoneNumber value from the expertData map
      String phoneNumber = expertsData['phoneNumber'];

      // Set the class variable phoneNumber with the retrieved value
        setState(() {
          this.phoneNumber = phoneNumber;
        });

    } else {
      // The expert with the given ID doesn't exist
      print('Expert with ID $EID not found.');
      return null;
    }
      
  } catch (e) {
    print('Error retrieving phone number: $e');
    return null;
  }
}






@override
  void initState() {
    super.initState();
    retrieveUserData();
    retrievePhoneNumber('E01');
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme data to determine the background color
    //final ThemeData themeData = Theme.of(context);

    // Replace this function with the one from the CustomDrawer class
    /*void _toggleDarkMode(bool value) {
      setState(() {
        widget.toggleDarkMode(value);
      });
    }*/

    // Calculate the progress value based on bookingCount and totalBooking
    double _progressValue = _bookingCount / _totalBooking;

    // Convert the progress value from double to int
  int _progressPercentage = (_progressValue * 100).toInt();

  //Uri whatsapp = Uri.parse('https://wa.me/$phoneNumber');
  
  String formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  Uri whatsappURL = Uri.parse('whatsapp://send?phone=$formattedPhoneNumber');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Set the AppBar color to teal
        title: Text(
          'MaidEasy App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
          GestureDetector(
            onTap: (()async {
              launchUrl(whatsappURL);
            }),
            child: Icon(
              FontAwesomeIcons.whatsapp,
              size: 30,
              color: Colors.green,
            ),
          )
        ],
      ),
      // Pass the _toggleDarkMode function here
      // Add the custom drawer here
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for expert & chores',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                // Implement your search functionality here
              },
            ),
          ),

          //Category part

          Padding(
            padding: const EdgeInsets.all(15.0),//ni jarak container dgn fon
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showCustomDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), //border container
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                              Icons.wallet_giftcard_rounded, // Replace with the desired icon
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                              Text(
                                "Get Your Reward",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 35,),
                          Text(
                                        "${_bookingCount.toInt()}/${_totalBooking.toInt()}",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                          minHeight: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ),
          
        ],
      ),
    );
  }

}