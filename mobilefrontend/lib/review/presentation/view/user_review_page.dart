import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/application/bloc/review_state.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/presentation/view/review_edit_page.dart';

class UserReviewsPage extends StatefulWidget {
  @override
  _UserReviewsPageState createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends State<UserReviewsPage> {
  @override
  void initState() {
    super.initState();
    _getReviewsByUser();
  }

  Future<void> _getReviewsByUser() async {
    BlocProvider.of<ReviewBloc>(context).add(GetReviewsByUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Reviews',
          style: TextStyle(color: Colors.orange[800]),
        ),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReviewLoadedState) {
            final List<Review> reviews = state.reviews;
            return _buildReviewsList(reviews);
          } else if (state is ReviewErrorState) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Unknown state',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildReviewsList(List<Review> reviews) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final Review review = reviews[index];
        return Column(
          children: [
            ListTile(
              title: Text(
                'Review ID: ${review.reviewId}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job ID: ${review.jobId}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Content: ${review.content}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Rating: ${review.rate}',
                    style: TextStyle(color: Colors.white),
                  ),
                  // Add more details of the review as needed
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showEditReviewPage(review);
                    },
                    child: Icon(Icons.edit, color: Colors.orange[800]),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog(review.reviewId);
                    },
                    child: Icon(Icons.delete, color: Colors.orange[800]),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white), // Add Divider here
          ],
        );
      },
    );
  }

  void _showDeleteDialog(String reviewId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this review?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteReview(reviewId);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteReview(String reviewId) {
    BlocProvider.of<ReviewBloc>(context).add(DeleteReviewEvent(reviewId));
  }

  void _showEditReviewPage(Review review) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReviewPage(review: review),
      ),
    );
  }
}
