import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/job/infrastructure/repostory/job_repostory.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobilefrontend/job/application/bloc/job_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_event.dart';
import 'package:mobilefrontend/job/application/bloc/job_state.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/domain/model/update_job_model.dart';

class MockJobRepository extends Mock implements JobRepository {}

void main() {
  late MockJobRepository mockJobRepository;
  late JobBloc jobBloc;

  setUp(() {
    mockJobRepository = MockJobRepository();
    jobBloc = JobBloc(mockJobRepository);
  });

  tearDown(() {
    jobBloc.close();
  });

  group('JobBloc', () {
    final job = Job(
      title: 'Software Engineer',
      description: 'Develop mobile applications',
      createrId: 1,
      userType: UserType.EMPLOYEE,
      phonenumber: '1234567890',
    );

    final updateJobDto = UpdateJobDto(
      jobId: '1',
      title: 'Updated Title',
      description: 'Updated Description',
      salary: 50000,
      phonenumber: '1234567890',
    );

    blocTest<JobBloc, JobState>(
      'emits [JobLoadingState, JobSuccessState] when CreateJobEvent is added and succeeds',
      build: () {
        when(() => mockJobRepository.createJob(job))
            .thenAnswer((_) async => Job(
                  title: 'Software Engineer',
                  description: 'Develop mobile applications',
                  createrId: 1,
                  userType: UserType.EMPLOYEE,
                  phonenumber: '1234567890', /* provide required parameters */
                ));
        return jobBloc;
      },
      act: (bloc) => bloc.add(CreateJobEvent(job)),
      expect: () => [
        JobLoadingState(),
        const JobSuccessState('Job created successfully!'),
      ],
      verify: (_) {
        verify(() => mockJobRepository.createJob(job)).called(1);
      },
    );
    blocTest<JobBloc, JobState>(
      'emits [JobLoadingState, JobSuccessState] when UpdateJobEvent is added and succeeds',
      build: () {
        when(() =>
                mockJobRepository.updateJob(updateJobDto.jobId, updateJobDto))
            .thenAnswer((_) async => UpdateJobDto(
                  jobId: '1',
                  title: 'Updated Title',
                  description: 'Updated Description',
                  salary: 50000,
                  phonenumber: '1234567890',
                )); // Provide the appropriate response here
        return jobBloc;
      },
      act: (bloc) => bloc
          .add(UpdateJobEvent(jobId: updateJobDto.jobId, job: updateJobDto)),
      expect: () => [
        JobLoadingState(),
        const JobSuccessState('Job updated successfully!'),
      ],
      verify: (_) {
        verify(() =>
                mockJobRepository.updateJob(updateJobDto.jobId, updateJobDto))
            .called(1);
      },
    );
    blocTest<JobBloc, JobState>(
      'emits [JobLoadingState, JobSuccessState] when DeleteJobEvent is added and succeeds',
      build: () {
        when(() => mockJobRepository.deleteJob('1')).thenAnswer(
            (_) async => ''); // Provide the appropriate response here
        return jobBloc;
      },
      act: (bloc) => bloc.add(DeleteJobEvent('1')),
      expect: () => [
        JobLoadingState(),
        const JobSuccessState('Job deleted successfully!'),
      ],
      verify: (_) {
        verify(() => mockJobRepository.deleteJob('1')).called(1);
      },
    );
    blocTest<JobBloc, JobState>(
      'emits [JobLoadingState, JobLoadedState] when GetJobsByUserIdEvent is added and succeeds',
      build: () {
        when(() => mockJobRepository.getJobsByUserId(1)).thenAnswer(
            (_) async => [job]); // Provide the appropriate response here
        return jobBloc;
      },
      act: (bloc) => bloc.add(GetJobsByUserIdEvent(1)),
      expect: () => [
        JobLoadingState(),
        JobLoadedState([job]),
      ],
      verify: (_) {
        verify(() => mockJobRepository.getJobsByUserId(1)).called(1);
      },
    );

    // Add more bloc tests for other events as needed
  });
}
