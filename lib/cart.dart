import 'package:login_project_test1/expert_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            'Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Text('Your cart is empty.'),
        ),
      );
    } else {
      // Filter the cart items where isAddToCart is true
      final filteredCartItems = widget.cartItems
          .where((item) => item['isAddToCart'] == true)
          .toList();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal, // Set the app bar color to teal
          title: Text(
            'Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('cartItems').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            // Extract the cart items from the snapshot
            List<Map<String, dynamic>> cartItems = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> cartItem = cartItems[index];
                String userId = cartItem['userId'];
                String expertName = cartItem['expertName'];
                String expertDesc = cartItem['expertDesc'];
                double expertPrice = cartItem['expertPrice'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => expertProfile(
                          // Pass the expert details to the expert profile page
                          expertName: expertName,
                          expertDesc: expertDesc,
                          expertPrice: expertPrice,
                          // Add any other necessary details here
                        ),
                      ),
                    );
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      // Remove the item from the cart when swiped to the left
                      setState(() {
                        widget.cartItems.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('$expertName removed from cart'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: ListTile(
                      tileColor: Colors.teal[100],
                      selectedTileColor: Colors.blue[200],
                      title: Text(expertName),
                      subtitle: Text(expertDesc),
                      trailing: Text('RM $expertPrice'),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}

class CartBookingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('isAddToCart', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            // Display the relevant data from the bookings
            var booking = snapshot.data!.docs[index];
            return ListTile(
              title: Text('Booking ID: ${booking.id}'),
              // Add more fields as needed, e.g., booking date, time, etc.
            );
          },
        );
      },
    );
  }
}
