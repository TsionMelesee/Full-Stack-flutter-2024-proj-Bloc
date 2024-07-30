import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateReviewPage extends StatefulWidget {
  final String jobId;

  CreateReviewPage({required this.jobId});

  @override
  _CreateReviewPageState createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _reviewContentController = TextEditingController();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[900], // dark grey background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _reviewContentController,
              decoration: InputDecoration(labelText: 'Review Content'),

              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            SizedBox(height: 16.0),
            Text(
              'Rating: $_rating',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _createReview(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[900], // background color
              ),
              child: Text(
                'Create Review',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createReview(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final int authorId = sharedPreferences.getInt('userId') ?? 0;

    if (authorId == 0) {
      print('Error: userId is not available');
      return;
    }

    final review = Review(
      reviewId: '',
      content: _reviewContentController.text,
      rate: _rating,
      jobId: widget.jobId,
      authorId: authorId,
    );

    BlocProvider.of<ReviewBloc>(context).add(CreateReviewEvent(
      jobId: widget.jobId,
      review: review,
    ));
    Navigator.pop(context);
  }
}
