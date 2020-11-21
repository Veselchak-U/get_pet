import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:cats/import.dart';

part 'search.g.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({this.repo, this.category}) : super(const SearchState());

  final DatabaseRepository repo;
  final CategoryModel category;

  Future<bool> init({bool isReload}) async {
    // await Future.delayed(Duration(seconds: 2));
    var result = true;
    if (isReload != null && isReload) {
      emit(state.copyWith(status: SearchStatus.reload));
    } else {
      emit(state.copyWith(
        status: SearchStatus.busy,
        categoryFilter: category,
      ));
    }
    try {
      final List<CategoryModel> petCategories = await repo.readCategories();
      final List<ConditionModel> conditions = await repo.readConditions();
      final List<PetModel> foundPets = await repo.searchPets(
          categoryId: 'abe09048-c1dc-4f4b-87e3-421b7f34e07d', query: 'abyss');
      emit(state.copyWith(
        status: SearchStatus.ready,
        categories: petCategories,
        conditions: conditions,
        foundPets: foundPets,
      ));
    } catch (error) {
      print(error);
      result = false;
      // return Future.error(error);
    }
    return result;
  }

  void setCategoryFilter(CategoryModel category) {
    if (category == state.categoryFilter) {
      return; // no change
    }
    emit(state.copyWith(
      categoryFilter:
          category ?? CategoryModel(), // if null - clear categoryFilter
    ));
  }

  void setConditionFilter(ConditionModel condition) {
    if (condition == state.conditionFilter) {
      return; // no change
    }
    emit(state.copyWith(
      conditionFilter:
          condition ?? ConditionModel(), // if null - clear conditionFilter
    ));
  }
}

enum SearchStatus { initial, busy, reload, ready }

@CopyWith()
class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.categoryFilter,
    this.conditionFilter,
    this.conditions = const [],
    this.categories = const [],
    this.foundPets = const [],
  });

  final SearchStatus status;
  final CategoryModel categoryFilter;
  final ConditionModel conditionFilter;
  final List<ConditionModel> conditions;
  final List<CategoryModel> categories;
  final List<PetModel> foundPets;

  @override
  List<Object> get props => [
        status,
        categoryFilter,
        conditionFilter,
        conditions,
        categories,
        foundPets,
      ];
}
