import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/job/presentation/view/user_jobs.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/application/bloc/review_state.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/domain/model/update_review_model.dart';
import 'package:mobilefrontend/review/presentation/view/user_review_page.dart';
import 'package:mobilefrontend/user/presentation/view/user.dart';

class EditReviewPage extends StatefulWidget {
  final Review review;

  EditReviewPage({required this.review});

  @override
  _EditReviewPageState createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  late TextEditingController _contentController;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.review.content);
    _rating = widget.review.rate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Review'),
        backgroundColor: Colors.grey[900], // Dark grey app bar
      ),
      body: Container(
        color: Colors.grey[900], // Dark grey background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Review Content',
                labelStyle:
                    TextStyle(color: Colors.white), // Set label text color
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange), // Border color
                ),
              ),
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            SizedBox(height: 16.0),
            Text(
              'Rating:',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 40.0,
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
              onPressed: () => _updateReview(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[900], // Button color
              ),
              child: Text('Update Review'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateReview() {
    final UpdateReviewDto updatedReview = UpdateReviewDto(
      id: widget.review.reviewId,
      content: _contentController.text,
      rate: _rating,
    );
    BlocProvider.of<ReviewBloc>(context).add(UpdateReviewEvent(updatedReview));

    GoRouter.of(context).go('/user');
  }
}
