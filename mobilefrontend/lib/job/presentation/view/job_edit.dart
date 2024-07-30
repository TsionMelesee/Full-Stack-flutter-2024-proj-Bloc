import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/job/application/bloc/job_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_event.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/domain/model/update_job_model.dart';

class EditJobPage extends StatefulWidget {
  final String jobId;
  final Job job;

  const EditJobPage({Key? key, required this.jobId, required this.job})
      : super(key: key);

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _salaryController;
  late TextEditingController _phonenumberController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.job.title);
    _descriptionController =
        TextEditingController(text: widget.job.description);
    _salaryController =
        TextEditingController(text: widget.job.salary?.toString() ?? '');
    _phonenumberController =
        TextEditingController(text: widget.job.phonenumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Job',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange[800]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange[800]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phonenumberController,
              decoration: InputDecoration(
                labelText: 'Phone number',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange[800]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _salaryController,
              decoration: InputDecoration(
                labelText: 'Salary',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange[800]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _updateJob(context);
              },
              child: Text(
                'Update Job',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange[800]!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateJob(BuildContext context) {
    if (widget.job.jobId != null) {
      final updatedJob = UpdateJobDto(
        jobId: widget.job.jobId!,
        title: _titleController.text,
        description: _descriptionController.text,
        phonenumber: _phonenumberController.text,
        salary: _salaryController.text.isNotEmpty
            ? int.tryParse(_salaryController.text)
            : null,
      );

      BlocProvider.of<JobBloc>(context).add(
        UpdateJobEvent(jobId: widget.job.jobId!, job: updatedJob),
      );

      GoRouter.of(context).go('/jobseekers');
    } else {
      print('Error: JobId is null');
      Navigator.pop(context, false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }
}
