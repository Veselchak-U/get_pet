import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_pet/import.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseRepository extends Mock implements DatabaseRepository {}

void main() {
  MockDatabaseRepository mockDatabaseRepository;

  setUp(() {
    mockDatabaseRepository = MockDatabaseRepository();
    // when(mockDatabaseRepository.readConditions()).thenAnswer((_) => null);
    // when(mockDatabaseRepository.readCategories()).thenAnswer((_) => null);
  });

  group('AddPetCubit', () {
    blocTest<AddPetCubit, AddPetState>(
      'init()',
      build: () => AddPetCubit(repo: mockDatabaseRepository),
      act: (cubit) => cubit.init(),
      expect: const [
        AddPetState.busy(),
        AddPetState.ready(AddPetStateData()),
      ],
    );

    blocTest<AddPetCubit, AddPetState>(
      'addPet()',
      build: () => AddPetCubit(repo: mockDatabaseRepository),
      act: (cubit) => cubit.addPet(),
      expect: const [
        AddPetState.busy(),
        AddPetState.ready(AddPetStateData()),
        // AddPetState(status: AddPetStatus.busy),
        // AddPetState(status: AddPetStatus.ready),
      ],
    );
  });
}
