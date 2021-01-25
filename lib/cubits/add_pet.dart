import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:get_pet/import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_pet.freezed.dart';

class AddPetCubit extends Cubit<AddPetState> {
  AddPetCubit({
    this.repo,
    this.profileCubit,
  }) : super(const AddPetState.initial());

  final DatabaseRepository repo;
  final ProfileCubit profileCubit;
  List<BreedModel> _allBreeds;
  AddPetStateData _stateData = const AddPetStateData();

  Future<bool> init() async {
    var result = false;
    final isActiveUser = profileCubit.state.user.isActive;
    if (!isActiveUser) {
      emit(const AddPetState.inactive());
      return true;
    }
    emit(const AddPetState.busy());
    try {
      final List<ConditionModel> conditions = await repo.readConditions();
      final List<CategoryModel> categories = await repo.readCategories();
      _allBreeds = await repo.readBreeds();
      _stateData = _stateData.copyWith(
        conditions: conditions,
        categories: categories,
      );
      emit(AddPetState.ready(_stateData));
      result = true;
    } on dynamic catch (error, stackTrace) {
      saveError(error, stackTrace);
      emit(AddPetState.error(error, DateTime.now()));
    }
    return result;
  }

  void updateNewPet(PetModel newPet) {
    _stateData = _stateData.copyWith(
      newPet: newPet,
    );
    emit(AddPetState.ready(_stateData));
  }

  void setCategory(CategoryModel category) {
    // emit empty breeds
    final newPet = _stateData.newPet.copyWith(
      category: category,
      breed: null, //const BreedModel(), // set breed.name to null
    );
    _stateData = _stateData.copyWith(
      newPet: newPet,
      breedsByCategory: [],
    );
    emit(AddPetState.ready(_stateData));
    // emit breeds by category
    final List<BreedModel> breedsByCategory =
        _allBreeds.where((breed) => breed.categoryId == category.id).toList();
    _stateData = _stateData.copyWith(
      breedsByCategory: breedsByCategory,
    );
    emit(AddPetState.ready(_stateData));
  }

  Future<bool> addPet() async {
    bool result = false;
    if (_stateData.newPet.photos == null) {
      emit(AddPetState.error('Add a photo', DateTime.now()));
      return result;
    }
    emit(const AddPetState.busy());
    try {
      out('================================');
      out(_stateData.newPet);
      out('================================');
      await repo.createPet(_stateData.newPet);
      result = true;
    } on dynamic catch (error, stackTrace) {
      saveError(error, stackTrace);
      emit(AddPetState.error(error, DateTime.now()));
    }
    // finally {
    //   emit(AddPetState.ready(_stateData));
    // }
    return result;
  }

  void saveError(Object error, StackTrace stackTrace) {
    onError(error, stackTrace);
  }
}

@freezed
abstract class AddPetStateData with _$AddPetStateData {
  const factory AddPetStateData({
    @Default([]) List<CategoryModel> categories,
    @Default([]) List<ConditionModel> conditions,
    @Default([]) List<BreedModel> breedsByCategory,
    @Default(PetModel(id: '2020', liked: false)) PetModel newPet,
  }) = _AddPetStateData;
}

@freezed
abstract class AddPetState with _$AddPetState {
  const factory AddPetState.initial() = _Initial;

  const factory AddPetState.inactive() = _Inactive;

  const factory AddPetState.busy() = _Busy;

  const factory AddPetState.ready(AddPetStateData data) = _Ready;

  const factory AddPetState.error(
    Object error,
    DateTime timestamp, // for alwais new state
  ) = _ErrorState;
}
