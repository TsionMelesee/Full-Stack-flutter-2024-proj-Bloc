import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_event.dart';
import 'package:mobilefrontend/job/application/bloc/job_state.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/review/presentation/view/create_review_page.dart';
import 'package:mobilefrontend/review/presentation/view/jobs_review_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeJobsPage extends StatefulWidget {
  @override
  _EmployeeJobsPageState createState() => _EmployeeJobsPageState();
}

class _EmployeeJobsPageState extends State<EmployeeJobsPage> {
  @override
  void initState() {
    super.initState();
    _getEmployeeJob();
  }

  Future<void> _getEmployeeJob() async {
    _fetchEmployeeJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Employer Jobs',
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: BlocBuilder<JobBloc, JobState>(
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
              child: Text('Error: ${state.message}'),
            );
          } else {
            return Center(
              child: Text('Unknown state'),
            );
          }
        },
      ),
    );
  }

  Widget _buildJobsList(List<Job> jobs) {
    return SingleChildScrollView(
      child: Column(
        children: jobs.map((job) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                _navigateToJobReviewsPage(context, job.jobId!);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showCreateReviewDialog(context, job.jobId!);
                          },
                          child: Icon(Icons.rate_review, color: Colors.white),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[800]!,
                                Colors.orange[800]!,
                                Colors.orange[800]!,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              job.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'About: ${job.phonenumber}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Phone Number: ${job.phonenumber}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Salary: ${job.salary != null ? job.salary.toString() : 'Negotiable'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _navigateToJobReviewsPage(context, job.jobId!);
                          },
                          child: Text('See All Reviews',
                              style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Function to initiate fetching user's jobs
  void _fetchEmployeeJobs() {
    BlocProvider.of<JobBloc>(context).add(GetJobsForEmployeesEvent());
  }

  void _showCreateReviewDialog(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Create Review',
          style: TextStyle(color: Colors.white),
        ),
        content: CreateReviewPage(jobId: jobId),
      ),
    );
  }

  void _navigateToJobReviewsPage(BuildContext context, String jobId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobReviewsPage(jobId: jobId),
      ),
    );
  }
}
