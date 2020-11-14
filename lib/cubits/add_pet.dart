import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:cats/import.dart';

part 'add_pet.g.dart';

class AddPetCubit extends Cubit<AddPetState> {
  AddPetCubit({this.repo}) : super(const AddPetState());

  final DatabaseRepository repo;

  Future<bool> loadReferenceBooks() async {
    var result = true;
    emit(state.copyWith(status: AddPetStatus.busy));
    try {
      final List<ConditionModel> conditions = await repo.loadConditions();
      print('AddPetCubit conditions = $conditions');
      final List<CategoryModel> petCategories = await repo.loadPetCategories();
      print('AddPetCubit petCategories = $petCategories');
      emit(state.copyWith(
        status: AddPetStatus.ready,
        conditions: conditions,
        petCategories: petCategories,
      ));
    } catch (error) {
      print(error);
      result = false;
    }
    return result;
  }

  void updateNewPet(PetModel newPet) {
    emit(state.copyWith(newPet: newPet));
  }
}

enum AddPetStatus { initial, busy, ready }

@CopyWith()
class AddPetState extends Equatable {
  const AddPetState({
    this.status = AddPetStatus.initial,
    this.conditions = const [],
    this.petCategories = const [],
    this.newPet = const PetModel(),
  });

  final AddPetStatus status;
  final List<ConditionModel> conditions;
  final List<CategoryModel> petCategories;
  final PetModel newPet;

  @override
  List<Object> get props => [
        status,
        conditions,
        petCategories,
        newPet,
      ];
}
