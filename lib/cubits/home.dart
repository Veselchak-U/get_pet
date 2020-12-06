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

  Future<bool> load({bool isReload}) async {
    var result = true;
    if (isReload != null && isReload) {
      emit(state.copyWith(status: HomeStatus.reload));
    } else {
      emit(state.copyWith(status: HomeStatus.busy));
    }
    try {
      final List<ConditionModel> conditions =
          await dataRepository.readConditions(fromCash: false);
      final List<CategoryModel> petCategories =
          await dataRepository.readCategories(fromCash: false);
      final List<PetModel> newestPets = await dataRepository.readNewestPets();
      final List<VetModel> nearestVets = await dataRepository.readNearestVets();
      emit(state.copyWith(
        status: HomeStatus.ready,
        conditions: conditions,
        petCategories: petCategories,
        newestPets: newestPets,
        nearestVets: nearestVets,
      ));
    } catch (error) {
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
        throw 'Could not launch $phone';
      }
    }
  }

  void onTapPetLike({String petId}) {
    if (state.status == HomeStatus.reload) {
      return;
    } else {
      // local changes
      final List<PetModel> newPets = [...state.newestPets];
      final PetModel changedPet = newPets.firstWhere((PetModel e) => e.id == petId);
      final PetModel newPet = changedPet.copyWith(liked: !changedPet.liked);
      final index = newPets.indexOf(changedPet);
      newPets[index] = newPet;
      emit(state.copyWith(newestPets: newPets));
      // database changes
      dataRepository.updatePetLike(petId: petId, isLike: newPet.liked);
    }
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
}
