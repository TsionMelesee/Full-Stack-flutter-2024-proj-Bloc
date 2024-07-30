import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/job/application/bloc/job_bloc.dart';
import 'package:mobilefrontend/job/application/bloc/job_state.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/presentation/view/employee_job.dart';
import 'package:mockito/mockito.dart';

// Mock class for JobBloc
class JobWidgetTest extends Mock implements JobBloc {
  final _controller = StreamController<JobState>();

  @override
  Stream<JobState> get stream => _controller.stream;
}

void main() {
  void main() {
    testWidgets('EmployeeJobsPage UI Test', (WidgetTester tester) async {
      // Mock job data
      final List<Job> jobs = [
        Job(
            jobId: '1',
            title: 'Job 1',
            phonenumber: '1234567890',
            salary: 1000,
            createrId: 2,
            userType: UserType.EMPLOYEE,
            description: 'something'),
        Job(
            jobId: '2',
            title: 'Job 2',
            phonenumber: '1234567890',
            salary: 1000,
            createrId: 2,
            userType: UserType.EMPLOYEE,
            description: 'something'),
      ];

      // Create a mock JobBloc instance
      final jobBloc = JobWidgetTest();

      // Stub the stream to emit the initial state with the job data
      when(jobBloc.stream)
          .thenAnswer((_) => Stream.value(JobLoadedState(jobs)));

      // Define the test widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: jobBloc,
            child: EmployeeJobsPage(),
          ),
        ),
      );

      // Wait for loading to finish
      await tester.pump();

      // Verify that the correct widgets are displayed
      expect(find.text('Job 1'), findsOneWidget);
      expect(find.text('Job 2'), findsOneWidget);

      // Print the widget tree for debugging
      debugDumpApp();
    });
  }
}
