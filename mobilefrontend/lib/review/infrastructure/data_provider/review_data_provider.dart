import 'package:dio/dio.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/domain/model/update_review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewDataProvider {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ReviewDataProvider(this.dio, this.sharedPreferences);

  Future<Map<String, String>> _authenticatedHeaders() async {
    final token = sharedPreferences.getString('token');

    if (token == null) {
      throw Exception('Missing token in local storage.');
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Assuming JSON content type
    };
  }

  Future<Review> createReview(String jobId, Review review) async {
    try {
      final headers = await _authenticatedHeaders();
      final userId = sharedPreferences.getInt('userId');

      if (userId == null) {
        throw Exception('Missing userId in local storage.');
      }

      final response = await dio.post(
        'http://localhost:3000/review',
        data: {
          'userId': userId,
          'jobId': jobId,
          ...review.toJson(),
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        return Review.fromJson(data);
      } else {
        throw Exception('Failed to create review');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.delete(
          'http://localhost:3000/review/$reviewId',
          options: Options(headers: headers));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete review');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Review> updateReview(UpdateReviewDto dto) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.patch('http://localhost:3000/review',
          data: {
            ...dto.toJson(),
            'authorId': sharedPreferences.getInt('userId'),
          },
          options: Options(headers: headers));

      if (response.statusCode == 200) {
        final data = response.data;
        return Review.fromJson(data['editedReview']);
      } else {
        throw Exception('Failed to update review');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Review>> getReviewsByUser() async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.get(
        'http://localhost:3000/review/user/${sharedPreferences.getInt('userId')}',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((reviewJson) => Review.fromJson(reviewJson)).toList();
      } else {
        throw Exception('Failed to get reviews for user');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Review>> getReviewsByJobId(String jobId) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.get(
        'http://localhost:3000/review/job/$jobId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((reviewJson) => Review.fromJson(reviewJson)).toList();
      } else {
        throw Exception('Failed to get reviews for job');
      }
    } catch (error) {
      rethrow;
    }
  }
}
