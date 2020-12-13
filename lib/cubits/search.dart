import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:get_pet/import.dart';

part 'search.g.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({this.dataRepository, this.category})
      : super(const SearchState());

  final DatabaseRepository dataRepository;
  final CategoryModel category;

  Future<bool> init() async {
    var result = true;
    emit(state.copyWith(
      status: SearchStatus.busy,
      categoryFilter: category,
    ));
    try {
      final List<CategoryModel> categories =
          await dataRepository.readCategories();
      final List<ConditionModel> conditions =
          await dataRepository.readConditions();
      emit(state.copyWith(
        status: SearchStatus.ready,
        categories: categories,
        conditions: conditions,
      ));
      _searchPet();
    } catch (error) {
      out(error);
      result = false;
      return Future.error(error);
    }
    return result;
  }

  void setQueryFilter(String query) {
    emit(state.copyWith(
      queryFilter: query,
    ));
    _searchPet();
  }

  void setCategoryFilter(CategoryModel category) {
    emit(state.copyWith(
      categoryFilter: category ?? CategoryModel(),
    ));
    _searchPet();
  }

  void setConditionFilter(ConditionModel condition) {
    emit(state.copyWith(
      conditionFilter: condition ?? ConditionModel(),
    ));
    _searchPet();
  }

  void _searchPet() async {
    emit(state.copyWith(status: SearchStatus.busy));
    final List<PetModel> foundedPets = await dataRepository.searchPets(
      categoryId: state.categoryFilter?.id,
      conditionId: state.conditionFilter?.id,
      query: state.queryFilter,
    );
    emit(state.copyWith(
      status: SearchStatus.ready,
      foundedPets: foundedPets,
    ));
  }

  void onTapLike(PetModel pet) {
    if (state.status == SearchStatus.reload) {
      return;
    }
    out('SEARCHCUBIT onTapLike()');
    // database changes
    Future<bool> result = dataRepository.updatePetLike(pet);
    // local changes (optimistic update)
    final List<PetModel> foundedPets = [...state.foundedPets];
    final index = foundedPets.indexOf(pet);
    foundedPets[index] = pet.copyWith(liked: !pet.liked);
    emit(state.copyWith(foundedPets: foundedPets));
  }
}

enum SearchStatus { initial, busy, reload, ready }

@CopyWith()
class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.queryFilter = '',
    this.categoryFilter,
    this.conditionFilter,
    this.conditions = const [],
    this.categories = const [],
    this.foundedPets = const [],
  });

  final SearchStatus status;
  final String queryFilter;
  final CategoryModel categoryFilter;
  final ConditionModel conditionFilter;
  final List<ConditionModel> conditions;
  final List<CategoryModel> categories;
  final List<PetModel> foundedPets;

  @override
  List<Object> get props => [
        status,
        queryFilter,
        categoryFilter,
        conditionFilter,
        conditions,
        categories,
        foundedPets,
      ];
}
