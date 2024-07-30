import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/domain/model/update_job_model.dart';
import 'package:mobilefrontend/job/infrastructure/data_provider/job_data_provider.dart';

abstract class JobRepository {
  Future<Job> createJob(Job job);
  Future<void> deleteJob(String jobId);
  Future<UpdateJobDto> updateJob(String jobId, UpdateJobDto job);
  Future<List<Job>> getJobsByUserId(int userId);
  Future<List<Job>> getJobsForEmployees();
  Future<List<Job>> getJobsForJobSeekers();
}

class ConcreteJobRepository implements JobRepository {
  final JobDataProvider jobDataProvider;

  ConcreteJobRepository(this.jobDataProvider);

  @override
  Future<Job> createJob(Job job) async {
    return await jobDataProvider.createJob(job);
  }

  @override
  Future<void> deleteJob(String jobId) async {
    return await jobDataProvider.deleteJob(jobId);
  }

  @override
  Future<UpdateJobDto> updateJob(String jobId, UpdateJobDto job) async {
    return await jobDataProvider.updateJob(jobId, job);
  }

  @override
  Future<List<Job>> getJobsByUserId(int userId) async {
    return await jobDataProvider.getJobsByUserId(userId);
  }

  @override
  Future<List<Job>> getJobsForEmployees() async {
    return await jobDataProvider.getJobsForEmployees();
  }

  @override
  Future<List<Job>> getJobsForJobSeekers() async {
    return await jobDataProvider.getJobsForJobSeekers();
  }
}
