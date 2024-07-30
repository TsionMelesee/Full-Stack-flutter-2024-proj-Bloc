import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/application/bloc/review_state.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';

class JobReviewsPage extends StatefulWidget {
  final String jobId;

  JobReviewsPage({required this.jobId});

  @override
  _JobReviewsPageState createState() => _JobReviewsPageState();
}

class _JobReviewsPageState extends State<JobReviewsPage> {
  @override
  void initState() {
    super.initState();
    _getReviews();
  }

  Future<void> _getReviews() async {
    BlocProvider.of<ReviewBloc>(context)
        .add(GetReviewsByJobIdEvent(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Reviews for the Job',
          style: TextStyle(color: Colors.orange),
        ),
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
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Center(
              child: Text('Unknown state'),
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
          child: ListTile(
            tileColor: Colors.black,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content: ${review.content}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      color: i < review.rate ? Colors.orange : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
