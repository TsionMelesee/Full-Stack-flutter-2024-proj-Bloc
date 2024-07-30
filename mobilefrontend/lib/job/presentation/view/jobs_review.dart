import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/application/bloc/review_state.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';

class ReviewsPage extends StatelessWidget {
  final String jobId;

  ReviewsPage({required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // dark grey background
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Reviews',
          style: TextStyle(color: Colors.white),
        ),
      ),
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
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Rating: ${review.rate.toString()}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
