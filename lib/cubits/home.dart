import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:get_pet/import.dart';
import 'package:url_launcher/url_launcher.dart';

part 'home.g.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({this.dataRepository}) : super(const HomeState());

  final DatabaseRepository dataRepository;

  // TODO: subscribe to update newestPets from repo

  Future<bool> load({bool isReload = false}) async {
    var result = true;
    if (isReload) {
      out('HomeCubit RELOADING');
      emit(state.copyWith(status: HomeStatus.reload));
    } else {
      emit(state.copyWith(status: HomeStatus.busy));
    }
    try {
      final List<ConditionModel> conditions =
          await dataRepository.readConditions(fromCash: isReload);
      final List<CategoryModel> petCategories =
          await dataRepository.readCategories(fromCash: isReload);
      final List<PetModel> newestPets =
          await dataRepository.readNewestPetsWithLikes();
      final List<VetModel> nearestVets = await dataRepository.readNearestVets();
      emit(state.copyWith(
        status: HomeStatus.ready,
        conditions: conditions,
        petCategories: petCategories,
        newestPets: newestPets,
        nearestVets: nearestVets,
      ));
    } on dynamic catch (error) {
      out(error);
      result = false;
      return Future.error(error);
    }
    return result;
  }

  Future<void> callToPhoneNumber({String phone}) async {
    if (phone == null || phone.isEmpty) {
      return;
    } else {
      final url = 'tel:$phone';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        out('Could not launch $phone');
      }
    }
  }

  void onTapLike(PetModel pet) {
    if (state.status == HomeStatus.reload) {
      return;
    }
    out('HOMECUBIT onTapLike()');
    // database changes
    dataRepository.updatePetLike(pet);
    // local changes (optimistic update)
    final List<PetModel> newestPets = [...state.newestPets];
    final index = newestPets.indexOf(pet);
    newestPets[index] = pet.copyWith(liked: !pet.liked);
    emit(state.copyWith(newestPets: newestPets));
  }

  Future<void> addNewPet(PetModel newPet) async {
    if (newPet == null) {
      return;
    }
    out('HOME_CUBIT addNewPet()');
    // local changes (optimistic update)
    final List<PetModel> newPets = [newPet, ...state.newestPets];
    emit(state.copyWith(newestPets: newPets));
    // database changes
    final List<PetModel> newestPets =
        await dataRepository.readNewestPetsWithLikes();
    emit(state.copyWith(newestPets: newestPets));
  }
}

enum HomeStatus { initial, busy, reload, ready }

@CopyWith()
class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.conditions = const [],
    this.petCategories = const [],
    this.newestPets = const [],
    this.nearestVets = const [],
  });

  final HomeStatus status;
  final List<ConditionModel> conditions;
  final List<CategoryModel> petCategories;
  final List<PetModel> newestPets;
  final List<VetModel> nearestVets;

  @override
  List<Object> get props => [
        status,
        conditions,
        petCategories,
        newestPets,
        nearestVets,
      ];

  @override
  String toString() => status.toString();
}
