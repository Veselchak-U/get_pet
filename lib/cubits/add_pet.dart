import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:cats/import.dart';

part 'add_pet.g.dart';

class AddPetCubit extends Cubit<AddPetState> {
  AddPetCubit({this.repo}) : super(const AddPetState());

  final DatabaseRepository repo;
  List<BreedModel> allBreeds;

  Future<bool> loadReferenceBooks() async {
    var result = true;
    emit(state.copyWith(status: AddPetStatus.busy));
    try {
      final List<ConditionModel> conditions = await repo.loadConditions();
      // print('AddPetCubit conditions = $conditions');
      final List<CategoryModel> categories = await repo.loadCategories();
      // print('AddPetCubit petCategories = $categories');
      allBreeds = await repo.loadBreeds();
      emit(state.copyWith(
        status: AddPetStatus.ready,
        conditions: conditions,
        categories: categories,
        // breeds: allBreeds,
      ));
    } catch (error) {
      print(error);
      result = false;
    }
    return result;
  }

  void updateNewPet(PetModel newPet) {
    emit(state.copyWith(newPet: newPet));
    // updateBreeds();
  }

  void setExternalUpdate(bool externalUpdate) {
    print('AddPetCubit setExternalUpdate = $externalUpdate');
    emit(state.copyWith(externalUpdate: externalUpdate));
  }

  void updateBreedsByCategory(CategoryModel category) {
    assert(category != null);
    // CategoryModel category = state.newPet.category;
    // if (category == null) {
    //   return;
    // }
    List<BreedModel> breedsByCategory =
        allBreeds.where((BreedModel e) => e.categoryId == category.id).toList();
    PetModel newPet = state.newPet.copyWith(breed: null);
    emit(state.copyWith(
      breedsByCategory: breedsByCategory,
      newPet: newPet,
    ));
  }
}

enum AddPetStatus { initial, busy, ready }

@CopyWith()
class AddPetState extends Equatable {
  const AddPetState({
    this.status = AddPetStatus.initial,
    this.conditions = const [],
    this.categories = const [],
    this.breedsByCategory = const [],
    this.newPet = const PetModel(),
    this.externalUpdate = false,
  });

  final AddPetStatus status;
  final List<ConditionModel> conditions;
  final List<CategoryModel> categories;
  final List<BreedModel> breedsByCategory;
  final PetModel newPet;
  final bool externalUpdate;

  @override
  List<Object> get props => [
        status,
        conditions,
        categories,
        breedsByCategory,
        newPet,
        externalUpdate,
      ];
}
