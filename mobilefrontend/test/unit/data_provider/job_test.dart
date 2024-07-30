import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilefrontend/job/infrastructure/data_provider/job_data_provider.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/domain/model/update_job_model.dart';

class MockDio extends Mock implements Dio {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('JobDataProvider', () {
    late MockDio mockDio;
    late MockSharedPreferences mockSharedPreferences;
    late JobDataProvider dataProvider;

    setUp(() {
      mockDio = MockDio();
      mockSharedPreferences = MockSharedPreferences();
      dataProvider = JobDataProvider(mockDio, mockSharedPreferences);
    });

    test('createJob - success', () async {
      // Arrange
      final job = Job(
        title: 'Software Engineer',
        description: 'Develop software applications',
        salary: 80000,
        createrId: 1,
        userType: UserType.EMPLOYEE,
        phonenumber: '1234567890',
      );
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockDio.post(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: {
                  'id': '1',
                  'createdAt': DateTime.now().toIso8601String(),
                  'updatedAt': DateTime.now().toIso8601String(),
                  'title': 'Software Engineer',
                  'description': 'Develop software applications',
                  'salary': 80000,
                  'createrId': 1,
                  'userType': 'EMPLOYEE',
                  'phonenumber': '1234567890',
                },
                statusCode: 201,
              ));

      // Act
      final createdJob = await dataProvider.createJob(job);

      // Assert
      expect(createdJob.title, 'Software Engineer');
      expect(createdJob.description, 'Develop software applications');
      expect(createdJob.salary, 80000);
      expect(createdJob.createrId, 1);
      expect(createdJob.userType, UserType.EMPLOYEE);
      expect(createdJob.phonenumber, '1234567890');
    });

    test('deleteJob - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockDio.delete(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                statusCode: 200,
              ));

      // Act
      await dataProvider.deleteJob('1');

      // Assert
      verify(() => mockDio.delete('http://localhost:3000/jobs/1',
          options: any(named: 'options'))).called(1);
    });

    test('updateJob - success', () async {
      // Arrange
      final job = UpdateJobDto(
        jobId: '1',
        title: 'Software Engineer',
        description: 'Develop software applications',
        salary: 80000,
        phonenumber: '1234567890',
      );
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockDio.patch(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: {
                  'jobId': '1',
                  'title': 'Software Engineer',
                  'description': 'Develop software applications',
                  'salary': 80000,
                  'phonenumber': '1234567890',
                },
                statusCode: 200,
              ));

      // Act
      final updatedJob = await dataProvider.updateJob('1', job);

      // Assert
      expect(updatedJob.jobId, '1');
      expect(updatedJob.title, 'Software Engineer');
      expect(updatedJob.description, 'Develop software applications');
      expect(updatedJob.salary, 80000);
      expect(updatedJob.phonenumber, '1234567890');
    });
    test('getJobsByUserId - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: {
                  'jobs': [
                    {
                      'id': '1',
                      'createdAt': DateTime.now().toIso8601String(),
                      'updatedAt': DateTime.now().toIso8601String(),
                      'title': 'Software Engineer',
                      'description': 'Develop software applications',
                      'salary': 80000,
                      'createrId': 1,
                      'userType': 'EMPLOYEE',
                      'phonenumber': '1234567890',
                    },
                  ],
                },
                statusCode: 200,
              ));

      // Act
      final jobs = await dataProvider.getJobsByUserId(1);

      // Assert
      expect(jobs.length, 1);
      expect(jobs[0].title, 'Software Engineer');
      expect(jobs[0].description, 'Develop software applications');
      expect(jobs[0].salary, 80000);
      expect(jobs[0].createrId, 1);
      expect(jobs[0].userType, UserType.EMPLOYEE);
      expect(jobs[0].phonenumber, '1234567890');
    });

    test('getJobsForEmployees - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: {
                  'jobs': [
                    {
                      'id': '1',
                      'createdAt': DateTime.now().toIso8601String(),
                      'updatedAt': DateTime.now().toIso8601String(),
                      'title': 'Software Engineer',
                      'description': 'Develop software applications',
                      'salary': 80000,
                      'createrId': 1,
                      'userType': 'EMPLOYEE',
                      'phonenumber': '1234567890',
                    },
                  ],
                },
                statusCode: 200,
              ));

      // Act
      final jobs = await dataProvider.getJobsForEmployees();

      // Assert
      expect(jobs.length, 1);
      expect(jobs[0].title, 'Software Engineer');
      expect(jobs[0].description, 'Develop software applications');
      expect(jobs[0].salary, 80000);
      expect(jobs[0].createrId, 1);
      expect(jobs[0].userType, UserType.EMPLOYEE);
      expect(jobs[0].phonenumber, '1234567890');
    });

    test('getJobsForJobSeekers - success', () async {
      // Arrange
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('dummy_token');
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response<dynamic>(
                requestOptions: RequestOptions(path: 'dummy_path'),
                data: {
                  'jobs': [
                    {
                      'id': '1',
                      'createdAt': DateTime.now().toIso8601String(),
                      'updatedAt': DateTime.now().toIso8601String(),
                      'title': 'Software Engineer',
                      'description': 'Develop software applications',
                      'salary': 80000,
                      'createrId': 1,
                      'userType': 'EMPLOYEE',
                      'phonenumber': '1234567890',
                    },
                  ],
                },
                statusCode: 200,
              ));

      // Act
      final jobs = await dataProvider.getJobsForJobSeekers();

      // Assert
      expect(jobs.length, 1);
      expect(jobs[0].title, 'Software Engineer');
      expect(jobs[0].description, 'Develop software applications');
      expect(jobs[0].salary, 80000);
      expect(jobs[0].createrId, 1);
      expect(jobs[0].userType, UserType.EMPLOYEE);
      expect(jobs[0].phonenumber, '1234567890');
    });
  });
}
