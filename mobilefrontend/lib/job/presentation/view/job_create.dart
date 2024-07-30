import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/job/application/bloc/job_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_event.dart';
import 'package:mobilefrontend/job/application/bloc/job_state.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateJobPage extends StatefulWidget {
  @override
  _CreateJobPageState createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _userType = ValueNotifier<UserType>(UserType.EMPLOYEE);
  final _phonenumber = TextEditingController();

  @override
  void dispose() {
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _salaryController.dispose();
    _userType.dispose();
    _phonenumber.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  Future<void> _submitJob() async {
    if (_formKey.currentState!.validate()) {
      final sharedPreferences = await SharedPreferences.getInstance();
      final userId = sharedPreferences.getInt('userId');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ID not found. Please log in again.'),
          ),
        );
        return;
      }

      final job = Job(
        title: _jobTitleController.text,
        description: _jobDescriptionController.text,
        salary: int.tryParse(_salaryController.text),
        createrId: userId,
        userType: _userType.value,
        phonenumber: _phonenumber.text,
      );
      BlocProvider.of<JobBloc>(context).add(CreateJobEvent(job));

      // Show pop-up message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Job Created Successfully'),
            content: Text('Your job has been created successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  GoRouter.of(context).go('/user'); // Navigate to '/user' route
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Job',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _jobTitleController,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange[800]!),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a job title' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _jobDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Job Description',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange[800]!),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  maxLines: null,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a job description' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phonenumber,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange[800]!),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _salaryController,
                  decoration: InputDecoration(
                    labelText: 'Salary (Optional)',
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
                  validator: (value) {
                    if (value!.isEmpty) return null;
                    final parsedValue = int.tryParse(value);
                    return parsedValue == null ? 'Invalid salary format' : null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<UserType>(
                  value: _userType.value,
                  items: UserType.values
                      .map((user) => DropdownMenuItem(
                            value: user,
                            child: Text(user.toString().split('.').last),
                          ))
                      .toList(),
                  onChanged: (value) => _userType.value = value!,
                  decoration: InputDecoration(
                    labelText: 'User Type',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange[800]!),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitJob,
                  child: const Text(
                    'Create Job',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
