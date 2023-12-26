import 'package:login_project_test1/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorite.dart';
import 'payment.dart';

class expertProfile extends StatefulWidget {
  final String? expertName;
  final String? expertDesc;
  final double? expertPrice;
  final String? expertRate;
  final String? imagePath;
  const expertProfile({
    super.key,
    required this.expertName,
    this.expertDesc,
    this.expertPrice,
    this.expertRate,
    this.imagePath,
  });

  @override
  State<expertProfile> createState() => _expertProfileState();
}

class _expertProfileState extends State<expertProfile> {
  bool isFavorite = false;
  late DateTime selectedDate;

  late TimeOfDay selectedTime;
  String phoneNumber = '0';

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List<Map<String, dynamic>> cartItems = [];

  final CollectionReference _bookings =
      FirebaseFirestore.instance.collection("booking");
  final CollectionReference _experts =
      FirebaseFirestore.instance.collection("experts");
  @override
  void initState() {
    super.initState();
    retrievePhoneNumber('E01');

    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    // Initialize controllers with the current date and time
    dateController.text =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    timeController.text = '${selectedTime.hour}:${selectedTime.minute}';
  }

  Future<String> _getImageUrl() async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(widget.imagePath);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Handle any errors that might occur during URL retrieval
      print('Error retrieving image URL: $e');
      return '';
    }
  }

  void _addToFavorites() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    Map<String, dynamic> favoriteItem = {
      'userId': userId,
      'expertName': widget.expertName!,
      'expertDesc': widget.expertDesc!,
      'expertPrice': widget.expertPrice!,
      'expertRate': widget.expertRate!,
      'isAddToFavorite': true,
    };

    FirebaseFirestore.instance
        .collection('favoriteItems')
        .add(favoriteItem)
        .then((docRef) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Added to Favorites'),
            content: Text('The expert has been added to your favorites.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add the expert to favorites.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  void _addToCart() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
Map<String, dynamic> cartItem = {
      'expertName': widget.expertName!,
      'expertDesc': widget.expertDesc!,
      'expertPrice': widget.expertPrice!,
      'expertRate': widget.expertRate!,
      'userId': userId, // Add the 'userId' to the cart item
      'isAddToCart': true, // Set isAddToCart to true when adding to cart
    };

    setState(() {
      cartItems.add(cartItem);
    });
    // Get the current user ID from Firebase Auth
    // Show a dialog box with the message "Added To Cart"
    // Add expert details and user ID to the "cartItems" collection
    FirebaseFirestore.instance.collection('cartItems').add({
      'userId': userId,
      'expertName': widget.expertName!,
      'expertDesc': widget.expertDesc!,
      'expertPrice': widget.expertPrice!,
      // Add more fields if needed
    }).then((docRef) {
      // Show a dialog box with the message "Added To Cart"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Added to Cart'),
            content: Text('The expert has been added to your cart.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add the expert to the cart.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  void _submitBooking(bool isAddToCart, bool isBooked) async {
    // Get the selected date and time from the controllers
    String selectedDate = dateController.text;
    String selectedTime = timeController.text;

    // Add a new document to the "booking" collection with the date and time
    await _bookings.add({
      'date': selectedDate,
      'time': selectedTime,
      'isAddToCart': isAddToCart,
      'isBooked': isBooked,
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          expertName: widget.expertName!,
          expertPrice: widget.expertPrice!,
          bookingDate: dateController.text,
          bookingTime: timeController.text,
        ),
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          child: _buildDateTimePickerForm(),
          padding: EdgeInsets.all(16.0),
          height: 300,
        );
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text =
            '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = '${selectedTime.hour}:${selectedTime.minute}';
      });
    }
  }
Widget _buildDateTimePickerForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //date picker
        TextField(
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            labelText: 'Select Date:',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: dateController,
        ),
        SizedBox(
          height: 20,
        ),
        //time picker
        TextField(
          readOnly: true,
          onTap: () => _selectTime(context),
          decoration: InputDecoration(
            hintText: 'Select Time:',
            suffixIcon: Icon(Icons.access_time),
          ),
          controller: timeController,
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {
            bool isAddToCart = false;
            bool isBooked = true;
            _submitBooking(isAddToCart, isBooked);
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal[200],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Center(
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<String?> retrievePhoneNumber(String EID) async {
    try {
      // Get the reference to the expert document using the expertId
      DocumentSnapshot<Map<String, dynamic>> expertsSnapshot =
          await FirebaseFirestore.instance
              .collection('experts')
              .doc('424n7BNdK41bIa0QmmUa')
              .get();

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
  Widget build(BuildContext context) {
    String formattedPhoneNumber =
        phoneNumber.replaceAll(RegExp(r'[^\d]'), ''); //new
    Uri whatsappURL =
        Uri.parse('whatsapp://send?phone=$formattedPhoneNumber'); //new
return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            'Profile',
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
                // Navigate to the cart page when the cart icon is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: cartItems),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder<String>(
                    future:
                        _getImageUrl(), // Call the function to get the image URL
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.teal[100],
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.teal[100],
                          child: Icon(Icons.error),
                        );
                      } else if (snapshot.hasData) {
                        final imageUrl = snapshot.data;
                        return CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.teal[100],
                          child: CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(imageUrl!),
                          ),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.teal[100],
                          child: Icon(Icons.image),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          _addToFavorites();
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        )),
                    GestureDetector(
                      onTap: (() async {
                        launchUrl(whatsappURL);
                      }),
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        size: 30,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(children: [
Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.expertName}',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'RM ${widget.expertPrice}',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                              ),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.expertDesc}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${widget.expertRate}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.star)
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              _addToCart();
                            },
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.teal[200],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Center(
                                child: const Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              _showDateTimePicker(context);
                            },
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.teal[200],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Center(
                                child: const Text(
                                  'Book Now',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ])
              ],
            ),
          ),
        ));
  }
}