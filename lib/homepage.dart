import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'cart.dart';
import 'category/aircond_maintenance.dart';
import 'category/car_washing.dart';
import 'category/house_cleaning.dart';
import 'category/lawn_maintenance.dart';
import 'category/house_disinfection.dart';
import 'category/house_painting.dart';
import 'drawer_widget.dart';
import 'expert_profile.dart';
import 'favorite.dart';

class HomePage extends StatefulWidget {
  final Function(bool) toggleDarkMode;
  final bool isDarkModeEnabled;
  HomePage({required this.toggleDarkMode, required this.isDarkModeEnabled});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> latestBookingStream;

  final TextEditingController _textEditingController = TextEditingController();
  final List<String> categories = [
    'Aircond Maintenance',
    'Car Washing',
    'House Cleaning',
    'Lawn Maintenance',
    'House Disinfection',
    'House Painting',
  ];

  final List<String> categoryImageAssets = [
    'assets/images/aircond.png',
    'assets/images/carwash.png',
    'assets/images/houseclean.png',
    'assets/images/lawn.png',
    'assets/images/house_dis.png',
    'assets/images/housepaint.png',
  ];

  final List<Color> categoryColors = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
  ];

  List<Map<String, dynamic>> cartItems = [];
  double _bookingCount = 0;
  final double _totalBooking =
      5; // Set the progress value between 0.0 and 1.0 // List of items in the cart

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    print('sign out belum');
  }

  Future<void> getDocumentDataFromFirestore(BuildContext context) async {
    try {
      DocumentSnapshot<Object?> documentSnapshot = await FirebaseFirestore
          .instance
          .collection('experts')
          .doc('RoA7BKODj7hwgl3tMwXw')
          .get();

      print('Masuk try');

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        // Use the null-aware operators to provide default values for nullable fields
        String expertName = 'Steven Johan';
        String expertDesc = 'car mechanic';
        double expertPrice = 4.99;
        String expertRate = '4.8';
        String imagePath = data?['imagePath'] ?? '';
        // ... Access other fields in the data
        print('Masuk doc');
        print('Document is $expertName');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => expertProfile(
              expertName: expertName,
              expertDesc: expertDesc,
              expertPrice: expertPrice,
              expertRate: expertRate,
              imagePath: imagePath,
              // Add any other necessary details here
            ),
          ),
        );
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
// Function to show the custom dialog
  void showCustomDialog(BuildContext context) {
    YYDialog().build(context)
      ..width = 300
      ..borderRadius = 20.0
      ..barrierDismissible = true
      ..barrierColor = Colors.transparent.withOpacity(0.8)
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
                'assets/images/car_wash.gif', // Replace with your own GIF path
                width: 200,
                height: 200,
              ),
              //SizedBox(height: 5),
              Text(
                'ONLY RM4.99 NANO CAR WASH',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Valid for 5 bookings per month',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_bookingCount >= 5) {
                    getDocumentDataFromFirestore(context);
                  } else {
                    Navigator.pop(
                        context); // Close the dialog when the button is pressed
                  } // Close the dialog when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(_bookingCount >= 5 ? 'Claim Now' : 'Close'),
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
            await FirebaseFirestore.instance
                .collection('user')
                .doc(userId)
                .get();

        if (userSnapshot.exists) {
          // Access the data in the user's document using the userSnapshot.data() method
          Map<String, dynamic> userData = userSnapshot.data()!;

          // Get the bookingCount value from the userData map and cast it to double
          double bookingCount =
              (userData['bookingCount'] as num?)?.toDouble() ?? 0.0;

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

  @override
  void initState() {
    super.initState();
    retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme data to determine the background color
    final ThemeData themeData = Theme.of(context);

    // Replace this function with the one from the CustomDrawer class
    void _toggleDarkMode(bool value) {
      setState(() {
        widget.toggleDarkMode(value);
      });
    }

    //Reward
    double _progressValue = _bookingCount / _totalBooking;
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cartItems),
                ),
              );
            },
          ),
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
        ],
      ),
      drawer: CustomDrawer(
        updateThemeMode:
            _toggleDarkMode, // Pass the _toggleDarkMode function here
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: ListView.builder(
              scrollDirection:
                  Axis.horizontal, // Set the scroll direction to horizontal

              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                final category = categories[index];
                final color = categoryColors[index % categoryColors.length];
                final imageAsset = categoryImageAssets[index];
                return GestureDetector(
                  onTap: () {
                    switch (category) {
                      case 'Aircond Maintenance':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AircondMaintenancePage(),
                          ),
                        );
                        break;
                      case 'Car Washing':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarWashingPage(),
                          ),
                        );
                        break;
                      case 'House Cleaning':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseCleaningPage(),
                          ),
                        );
                        break;
                      case 'Lawn Maintenance':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LawnMaintenancePage(),
                          ),
                        );
                        break;
                      case 'House Disinfection':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseDisinfectionPage(),
                          ),
                        );
                        break;
                      case 'House Painting':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HousePaintingPage(),
                          ),
);
                        break;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                imageAsset,
                                //fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            category,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: themeData.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
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
          //SizedBox(height: 16.0),
          Padding(
              padding: const EdgeInsets.all(15.0), //ni jarak container dgn fon
              child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        showCustomDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(8),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), //border container
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .wallet_giftcard_rounded, // Replace with the desired icon
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Get Your Reward",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Text(
"${_bookingCount.toInt()}/${_totalBooking.toInt()}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: LinearProgressIndicator(
                                  value: _progressValue,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.yellow),
                                  minHeight: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }
}

class LatestBookingCard extends StatelessWidget {
  final String expertName;
  final String bookingDate;
  final String bookingTime;

  LatestBookingCard({
    required this.expertName,
    required this.bookingDate,
    required this.bookingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Booking:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text('Expert Name: $expertName'),
            Text('Booking Date: $bookingDate'),
            Text('Booking Time: $bookingTime'),
          ],
        ),
      ),
    );
  }
}