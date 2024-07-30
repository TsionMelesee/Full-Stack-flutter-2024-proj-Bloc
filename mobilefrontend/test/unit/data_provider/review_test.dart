import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilefrontend/review/infrastructure/data_provider/review_data_provider.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/domain/model/update_review_model.dart';

class MockDio extends Mock implements Dio {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('ReviewDataProvider', () {
    late MockDio mockDio;
    late MockSharedPreferences mockSharedPreferences;
    late ReviewDataProvider dataProvider;

    setUp(() {
      mockDio = MockDio();
      mockSharedPreferences = MockSharedPreferences();
      dataProvider = ReviewDataProvider(mockDio, mockSharedPreferences);
    });

    test('createReview - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockSharedPreferences.getInt('userId')).thenReturn(123);
      when(() => mockDio.post(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: {
                  'id': '1',
                  'content': 'Great job!',
                  'rate': 5,
                  'jobId': '123',
                  'authorId': 123,
                },
                statusCode: 201,
              ));

      // Act
      final review = Review(
        reviewId: '1',
        content: 'Great job!',
        rate: 5,
        jobId: '123',
        authorId: 123,
      );
      final result = await dataProvider.createReview('123', review);

      // Assert
      expect(result.reviewId, '1');
      expect(result.content, 'Great job!');
      expect(result.rate, 5);
      expect(result.jobId, '123');
      expect(result.authorId, 123);
    });

    test('deleteReview - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockSharedPreferences.getInt('userId')).thenReturn(123);
      when(() => mockDio.delete(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                statusCode: 200,
              ));

      // Act
      await dataProvider.deleteReview('1');

      // Assert
      verify(() => mockDio.delete(any(), options: any(named: 'options')))
          .called(1);
    });

    test('updateReview - success', () async {
      // Arrange
      final updateReviewDto = UpdateReviewDto(
        id: '1',
        content: 'Updated content',
        rate: 4,
      );
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockSharedPreferences.getInt('userId')).thenReturn(123);
      when(() => mockDio.patch(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: {
                  'editedReview': {
                    'id': '1',
                    'content': 'Updated content',
                    'rate': 4,
                    'jobId': '123',
                    'authorId': 123,
                  },
                },
                statusCode: 200,
              ));

      // Act
      final result = await dataProvider.updateReview(updateReviewDto);

      // Assert
      expect(result.reviewId, '1');
      expect(result.content, 'Updated content');
      expect(result.rate, 4);
      expect(result.jobId, '123');
      expect(result.authorId, 123);
    });

    test('getReviewsByUser - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockSharedPreferences.getInt('userId')).thenReturn(123);
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: [
                  {
                    'id': '1',
                    'content': 'Great job!',
                    'rate': 5,
                    'jobId': '123',
                    'authorId': 123,
                  },
                ],
                statusCode: 200,
              ));

      // Act
      final result = await dataProvider.getReviewsByUser();

      // Assert
      expect(result.length, 1);
      expect(result[0].reviewId, '1');
      expect(result[0].content, 'Great job!');
      expect(result[0].rate, 5);
      expect(result[0].jobId, '123');
      expect(result[0].authorId, 123);
    });

    test('getReviewsByJobId - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockSharedPreferences.getInt('userId')).thenReturn(123);
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: [
                  {
                    'id': '1',
                    'content': 'Great job!',
                    'rate': 5,
                    'jobId': '123',
                    'authorId': 123,
                  },
                ],
                statusCode: 200,
              ));

      // Act
      final result = await dataProvider.getReviewsByJobId('123');

      // Assert
      expect(result.length, 1);
      expect(result[0].reviewId, '1');
      expect(result[0].content, 'Great job!');
      expect(result[0].rate, 5);
      expect(result[0].jobId, '123');
      expect(result[0].authorId, 123);
    });
  });
}
