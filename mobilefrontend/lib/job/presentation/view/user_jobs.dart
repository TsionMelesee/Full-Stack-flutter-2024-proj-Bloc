import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_event.dart';
import 'package:mobilefrontend/job/application/bloc/job_state.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/presentation/view/job_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserJobsPage extends StatefulWidget {
  @override
  _UserJobsPageState createState() => _UserJobsPageState();
}

class _UserJobsPageState extends State<UserJobsPage> {
  late int userId;

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  Future<void> _getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
    // Fetch user's jobs after getting the user ID
    _fetchUserJobs();
  }

  // Define the _fetchUserJobs method
  void _fetchUserJobs() {
    if (userId != 0) {
      BlocProvider.of<JobBloc>(context).add(GetJobsByUserIdEvent(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Jobs',
          style: TextStyle(color: Colors.orange[800]),
        ),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: BlocConsumer<JobBloc, JobState>(
        listener: (context, state) {
          if (state is JobSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: Duration(seconds: 2),
              ),
            );
            // After successful deletion, reload the job list
            _fetchUserJobs();
          }
        },
        builder: (context, state) {
          if (state is JobLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is JobLoadedState) {
            final List<Job> jobs = state.jobs;
            return _buildJobsList(jobs);
          } else if (state is JobErrorState) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Unknown state',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildJobsList(List<Job> jobs) {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final Job job = jobs[index];
        return Column(
          children: [
            ListTile(
              title: Text(
                job.title,
                style: TextStyle(color: Colors.orange, fontSize: 20),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.description ?? 'No description',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    job.phonenumber ?? 'No phone number',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    job.salary?.toString() ?? 'N/A',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange[800]),
                    onPressed: () async {
                      if (job.jobId != null) {
                        await _navigateToEditJobPage(context, job);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.orange[800]),
                    onPressed: () {
                      if (job.jobId != null) {
                        _deleteJob(job.jobId!);
                      }
                    },
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white), // Add Divider here
          ],
        );
      },
    );
  }

  void _deleteJob(String jobId) {
    if (jobId.isNotEmpty) {
      print('Deleting job with ID: $jobId'); // Debug print
      BlocProvider.of<JobBloc>(context).add(DeleteJobEvent(jobId));
    } else {
      print('Error: Job ID is null or empty'); // Debug print
    }
  }

  Future<void> _navigateToEditJobPage(BuildContext context, Job job) async {
    if (job.jobId != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditJobPage(
            jobId: job.jobId!,
            job: job,
          ),
        ),
      );

      // Check if the job was updated successfully, then refresh the job list
      if (result == true) {
        _fetchUserJobs();
      }
    } else {
      print('Error: JobId is null'); // Debug print
    }
  }
}
