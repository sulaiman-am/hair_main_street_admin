import 'package:flutter/material.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';

class Review {
  String? user;
  String? comment;
  double? stars;
  dynamic createdAt;

  Review({this.user, this.comment, this.stars, this.createdAt});
}

List<Review> reviews = [
  Review(
    user: 'User1',
    comment: 'Great product!',
    stars: 5,
    createdAt: DateTime.now(),
  ),
  Review(
    user: 'User2',
    comment: 'Good product, but could be better.',
    stars: 4,
    createdAt: DateTime.now(),
  ),
  Review(
    user: 'User3',
    comment: 'Not satisfied with the quality.',
    stars: 2,
    createdAt: DateTime.now(),
  ),
  // Add more reviews as needed
];

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Reviews'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          var review = reviews[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('${review.user} - ${review.stars} stars'),
              subtitle: Text(review.comment!),
              trailing: Text(
                '${review.createdAt}',
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
