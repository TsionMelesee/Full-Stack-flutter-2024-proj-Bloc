import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/application/bloc/review_state.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/domain/model/update_review_model.dart';
import 'package:mobilefrontend/review/infrastructure/repostory/review_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late MockReviewRepository mockReviewRepository;
  late ReviewBloc reviewBloc;

  setUp(() {
    mockReviewRepository = MockReviewRepository();
    reviewBloc = ReviewBloc(mockReviewRepository);
  });

  tearDown(() {
    reviewBloc.close();
  });

  final review = Review(
    reviewId: '1',
    content: 'Great job!',
    rate: 5,
    jobId: '123',
    authorId: 1,
  );

  final updateReviewDto = UpdateReviewDto(
    id: '1',
    content: 'Updated review',
    rate: 4,
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoadingState, ReviewSuccessState] when CreateReviewEvent is added and succeeds',
    build: () {
      when(() => mockReviewRepository.createReview('123', review))
          .thenAnswer((_) async => review);
      return reviewBloc;
    },
    act: (bloc) => bloc.add(CreateReviewEvent(jobId: '123', review: review)),
    expect: () => [
      ReviewLoadingState(),
      ReviewSuccessState('Review created successfully!', review),
    ],
    verify: (_) {
      verify(() => mockReviewRepository.createReview('123', review)).called(1);
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoadingState, ReviewSuccessState] when UpdateReviewEvent is added and succeeds',
    build: () {
      when(() => mockReviewRepository.updateReview(updateReviewDto))
          .thenAnswer((_) async => review);
      return reviewBloc;
    },
    act: (bloc) => bloc.add(UpdateReviewEvent(updateReviewDto)),
    expect: () => [
      ReviewLoadingState(),
      ReviewSuccessState('Review updated successfully!', review),
    ],
    verify: (_) {
      verify(() => mockReviewRepository.updateReview(updateReviewDto))
          .called(1);
    },
  );

  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoadingState, ReviewLoadedState] when DeleteReviewEvent is added and succeeds',
    build: () {
      when(() => mockReviewRepository.deleteReview('1'))
          .thenAnswer((_) async => null);
      when(() => mockReviewRepository.getReviewsByUser())
          .thenAnswer((_) async => [review]);
      return reviewBloc;
    },
    act: (bloc) => bloc.add(DeleteReviewEvent('1')),
    expect: () => [
      ReviewLoadingState(),
      ReviewLoadedState([review]),
    ],
    verify: (_) {
      verify(() => mockReviewRepository.deleteReview('1')).called(1);
      verify(() => mockReviewRepository.getReviewsByUser()).called(1);
    },
  );
  blocTest<ReviewBloc, ReviewState>(
    'emits [ReviewLoadingState, ReviewLoadedState] when GetReviewsByJobIdEvent is added and succeeds',
    build: () {
      when(() => mockReviewRepository.getReviewsByJobId('123'))
          .thenAnswer((_) async => [review]);
      return reviewBloc;
    },
    act: (bloc) => bloc.add(GetReviewsByJobIdEvent('123')),
    expect: () => [
      ReviewLoadingState(),
      ReviewLoadedState([review]),
    ],
    verify: (_) {
      verify(() => mockReviewRepository.getReviewsByJobId('123')).called(1);
    },
  );

  // Add more bloc tests for other events as needed
}
