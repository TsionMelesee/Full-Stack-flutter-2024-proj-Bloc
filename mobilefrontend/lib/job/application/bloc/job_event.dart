import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/domain/model/update_job_model.dart';

abstract class JobEvent {
  const JobEvent();
}

class LoadJobsEvent extends JobEvent {
  const LoadJobsEvent();
}

class CreateJobEvent extends JobEvent {
  final Job job;

  const CreateJobEvent(this.job);
}

class DeleteJobEvent extends JobEvent {
  final String jobId;

  const DeleteJobEvent(this.jobId);
}

class UpdateJobEvent extends JobEvent {
  final String jobId;
  final UpdateJobDto job; // Pass the job

  UpdateJobEvent({required this.jobId, required this.job});

  @override
  List<Object> get props => [jobId, job];
}

class GetJobsByUserIdEvent extends JobEvent {
  final int userId;

  const GetJobsByUserIdEvent(this.userId);
}

class GetJobsForEmployeesEvent extends JobEvent {
  const GetJobsForEmployeesEvent();
}

class GetJobsForJobSeekersEvent extends JobEvent {
  const GetJobsForJobSeekersEvent();
}
