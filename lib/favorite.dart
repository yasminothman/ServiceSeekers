import 'package:login_project_test1/expert_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Favorite Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('favoriteItems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Extract the favorite items from the snapshot
          List<Map<String, dynamic>> favoriteItems = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          if (favoriteItems.isEmpty) {
            return Center(
              child: Text('Your favorite list is empty.'),
            );
          } else {
            return ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> favoriteItem = favoriteItems[index];
                // Access the fields in the favoriteItem and display them
                String expertName = favoriteItem['expertName'];
                double expertPrice = favoriteItem['expertPrice'];
                String expertDesc = favoriteItem['expertDesc'];
                bool isFavorite = favoriteItem['isAddToFavorite'];

                return GestureDetector(
                  onTap: () {
                    // Navigate to the expert profile page when the tile is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => expertProfile(
                          expertName: expertName,
                          expertPrice: expertPrice,
                          expertDesc: expertDesc,
                          // Add any other necessary details here
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Adjust the radius as needed
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          tileColor: Colors.teal[100],
                          title: Text(
                              expertName + ' RM ' + expertPrice.toString()),
                          subtitle: Text(expertDesc),
                          trailing: Icon(Icons.favorite)),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}