import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/job/infrastructure/repostory/job_repostory.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobilefrontend/job/infrastructure/data_provider/job_data_provider.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/domain/model/update_job_model.dart';

class MockJobDataProvider extends Mock implements JobDataProvider {}

void main() {
  group('ConcreteJobRepository', () {
    late MockJobDataProvider mockJobDataProvider;
    late ConcreteJobRepository jobRepository;

    setUp(() {
      mockJobDataProvider = MockJobDataProvider();
      jobRepository = ConcreteJobRepository(mockJobDataProvider);
    });

    test('createJob - success', () async {
      // Arrange
      final job = Job(
        title: 'Software Engineer',
        description: 'Develop software applications',
        salary: 80000,
        createrId: 123,
        userType: UserType.EMPLOYEE,
        phonenumber: '1234567890',
      );
      when(() => mockJobDataProvider.createJob(job))
          .thenAnswer((_) async => job);

      // Act
      final result = await jobRepository.createJob(job);

      // Assert
      expect(result, job);
    });

    test('deleteJob - success', () async {
      // Arrange
      const jobId = '123';
      when(() => mockJobDataProvider.deleteJob(jobId))
          .thenAnswer((_) async => null);

      // Act
      await jobRepository.deleteJob(jobId);

      // Assert
      verify(() => mockJobDataProvider.deleteJob(jobId)).called(1);
    });

    test('updateJob - success', () async {
      // Arrange
      const jobId = '123';
      final updateJobDto = UpdateJobDto(
        jobId: jobId,
        title: 'Updated Title',
        description: 'Updated Description',
        salary: 90000,
        phonenumber: '9876543210',
      );
      when(() => mockJobDataProvider.updateJob(jobId, updateJobDto))
          .thenAnswer((_) async => updateJobDto);

      // Act
      final result = await jobRepository.updateJob(jobId, updateJobDto);

      // Assert
      expect(result, updateJobDto);
    });

    test('getJobsByUserId - success', () async {
      // Arrange
      const userId = 123;
      final jobs = [
        Job(
          title: 'Software Engineer',
          description: 'Develop software applications',
          salary: 80000,
          createrId: userId,
          userType: UserType.EMPLOYEE,
          phonenumber: '1234567890',
        ),
      ];
      when(() => mockJobDataProvider.getJobsByUserId(userId))
          .thenAnswer((_) async => jobs);

      // Act
      final result = await jobRepository.getJobsByUserId(userId);

      // Assert
      expect(result, jobs);
    });

    test('getJobsForEmployees - success', () async {
      // Arrange
      final jobs = [
        Job(
          title: 'Software Engineer',
          description: 'Develop software applications',
          salary: 80000,
          createrId: 123,
          userType: UserType.EMPLOYEE,
          phonenumber: '1234567890',
        ),
      ];
      when(() => mockJobDataProvider.getJobsForEmployees())
          .thenAnswer((_) async => jobs);

      // Act
      final result = await jobRepository.getJobsForEmployees();

      // Assert
      expect(result, jobs);
    });

    test('getJobsForJobSeekers - success', () async {
      // Arrange
      final jobs = [
        Job(
          title: 'Software Engineer',
          description: 'Develop software applications',
          salary: 80000,
          createrId: 123,
          userType: UserType.JOB_SEEKER,
          phonenumber: '1234567890',
        ),
      ];
      when(() => mockJobDataProvider.getJobsForJobSeekers())
          .thenAnswer((_) async => jobs);

      // Act
      final result = await jobRepository.getJobsForJobSeekers();

      // Assert
      expect(result, jobs);
    });
  });
}
