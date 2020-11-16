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
      final List<CategoryModel> categories = await repo.loadCategories();
      allBreeds = await repo.loadBreeds();
      emit(state.copyWith(
        status: AddPetStatus.ready,
        conditions: conditions,
        categories: categories,
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

  void setExternalUpdate(bool externalUpdate) {
    emit(state.copyWith(externalUpdate: externalUpdate));
  }

  void setCategory(CategoryModel category) {
    // emit empty breeds
    emit(state.copyWith(
      newPet: state.newPet.copyWith(
        category: category,
        breed: BreedModel(), // set breed.name to null
      ),
      breeds: [],
    ));
    // emit breeds by category
    List<BreedModel> breedsByCategory =
        allBreeds.where((BreedModel e) => e.categoryId == category.id).toList();
    emit(state.copyWith(breeds: breedsByCategory));
  }
}

enum AddPetStatus { initial, busy, ready }

@CopyWith()
class AddPetState extends Equatable {
  const AddPetState({
    this.status = AddPetStatus.initial,
    this.conditions = const [],
    this.categories = const [],
    this.breeds = const [],
    this.newPet = const PetModel(),
    this.externalUpdate = false,
  });

  final AddPetStatus status;
  final List<ConditionModel> conditions;
  final List<CategoryModel> categories;
  final List<BreedModel> breeds;
  final PetModel newPet;
  final bool externalUpdate;

  @override
  List<Object> get props => [
        status,
        conditions,
        categories,
        breeds,
        newPet,
        externalUpdate,
      ];
}
