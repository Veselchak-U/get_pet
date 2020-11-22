import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:cats/import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_pet.g.dart';

class AddPetCubit extends Cubit<AddPetState> {
  AddPetCubit({this.repo}) : super(const AddPetState());

  final DatabaseRepository repo;
  List<BreedModel> allBreeds;

  Future<bool> init() async {
    var result = true;
    emit(state.copyWith(status: AddPetStatus.busy));
    try {
      final List<ConditionModel> conditions = await repo.readConditions();
      final List<CategoryModel> categories = await repo.readCategories();
      allBreeds = await repo.readBreeds();
      emit(state.copyWith(
        status: AddPetStatus.ready,
        conditions: conditions,
        categories: categories,
      ));
    } catch (error) {
      print(error);
      result = false;
      return Future.error(error);
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
      breedsByCategory: [],
    ));
    // emit breeds by category
    List<BreedModel> breedsByCategory =
        allBreeds.where((BreedModel e) => e.categoryId == category.id).toList();
    emit(state.copyWith(breedsByCategory: breedsByCategory));
  }

  void addPet() async {
    final addedPet = await repo.createPet(state.newPet);
  }
}

enum AddPetStatus { initial, busy, ready }

@CopyWith()
class AddPetState extends Equatable {
  const AddPetState({
    this.status = AddPetStatus.initial,
    this.categories = const [],
    this.conditions = const [],
    this.breedsByCategory = const [],
    this.newPet = const PetModel(),
    this.externalUpdate = false,
  });

  final AddPetStatus status;
  final List<CategoryModel> categories;
  final List<ConditionModel> conditions;
  final List<BreedModel> breedsByCategory;
  final PetModel newPet;
  final bool externalUpdate;

  @override
  List<Object> get props => [
        status,
        categories,
        conditions,
        breedsByCategory,
        newPet,
        externalUpdate,
      ];
}
