import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_event.dart';
import 'package:mobilefrontend/job/application/bloc/job_state.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/domain/model/update_job_model.dart';
import 'package:mobilefrontend/job/infrastructure/repostory/job_repostory.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final JobRepository
      jobRepository; // Use JobRepository instead of JobDataProvider

  JobBloc(this.jobRepository) : super(JobInitialState()) {
    on<CreateJobEvent>((event, emit) => _createJob(event.job, emit));
    on<DeleteJobEvent>((event, emit) => _deleteJob(event.jobId, emit));
    on<UpdateJobEvent>(
        (event, emit) => _updateJob(event.jobId, event.job, emit));
    on<GetJobsByUserIdEvent>(
        (event, emit) => _getJobsByUserId(event.userId, emit));
    on<GetJobsForEmployeesEvent>((event, emit) => _getJobsForEmployees(emit));
    on<GetJobsForJobSeekersEvent>((event, emit) => _getJobsForJobSeekers(emit));
  }

  Future<void> _createJob(Job job, Emitter<JobState> emit) async {
    try {
      emit(JobLoadingState());
      await jobRepository
          .createJob(job); // Use jobRepository instead of jobDataProvider
      emit(const JobSuccessState("Job created successfully!"));
    } catch (error) {
      emit(JobErrorState(error.toString()));
    }
  }

  Future<void> _deleteJob(String jobId, Emitter<JobState> emit) async {
    try {
      emit(JobLoadingState());
      await jobRepository
          .deleteJob(jobId); // Use jobRepository instead of jobDataProvider
      emit(const JobSuccessState("Job deleted successfully!"));
    } catch (error) {
      emit(JobErrorState(error.toString()));
    }
  }

  Future<void> _updateJob(
      String jobId, UpdateJobDto job, Emitter<JobState> emit) async {
    try {
      emit(JobLoadingState());
      await jobRepository.updateJob(
          jobId, job); // Use jobRepository instead of jobDataProvider
      emit(const JobSuccessState("Job updated successfully!"));
    } catch (error) {
      emit(JobErrorState(error.toString()));
    }
  }

  Future<void> _getJobsByUserId(int userId, Emitter<JobState> emit) async {
    try {
      emit(JobLoadingState());
      final jobs = await jobRepository.getJobsByUserId(
          userId); // Use jobRepository instead of jobDataProvider
      emit(JobLoadedState(jobs));
    } catch (error) {
      emit(JobErrorState(error.toString()));
    }
  }

  Future<void> _getJobsForEmployees(Emitter<JobState> emit) async {
    try {
      emit(JobsForEmployeesLoadingState());
      final jobs = await jobRepository
          .getJobsForEmployees(); // Use jobRepository instead of jobDataProvider
      emit(JobLoadedState(jobs));
    } catch (error) {
      emit(JobErrorState(error.toString()));
      emit(
          JobInitialState()); // Revert back to initial state if an error occurs
    }
  }

  Future<void> _getJobsForJobSeekers(Emitter<JobState> emit) async {
    try {
      emit(JobLoadingState());
      final jobs = await jobRepository
          .getJobsForJobSeekers(); // Use jobRepository instead of jobDataProvider
      emit(JobLoadedState(jobs));
    } catch (error) {
      emit(JobErrorState(error.toString()));
    }
  }
}
