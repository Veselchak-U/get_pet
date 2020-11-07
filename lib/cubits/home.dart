import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cats/import.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({this.repo}) : super(const HomeState());

  final DatabaseRepository repo;

  Future<bool> load() async {
    var result = true;
    emit(state.copyWith(status: HomeStatus.busy));
    try {
      final int notificationCount = await repo.loadNotificationCount();
      final String userAvatarImage = await repo.loadUserAvatarImage();
      final List<ConditionModel> conditions = await repo.loadConditions();
      final List<CategoryModel> petCategories = await repo.loadPetCategories();
      final List<PetModel> newestPets = await repo.loadNewestPets();
      final List<VetModel> nearestVets = await repo.loadNearestVets();
      emit(state.copyWith(
        status: HomeStatus.ready,
        notificationCount: notificationCount,
        userAvatarImage: userAvatarImage,
        conditions: conditions,
        petCategories: petCategories,
        newestPets: newestPets,
        nearestVets: nearestVets,
      ));
    } catch (error) {
      print(error);
      result = false;
    }
    return result;
  }

  void addNotification() {
    emit(state.copyWith(notificationCount: state.notificationCount + 1));
  }

  void clearNotifications() {
    emit(state.copyWith(notificationCount: 0));
  }

  // Future<void> callToPhoneNumber({String phone}) async {
  //   if (phone == null || phone.isEmpty) {
  //     return;
  //   } else {
  //     if (await canLaunch('tel:$phone')) {
  //       await launch(phone);
  //     } else {
  //       throw 'Could not launch $phone';
  //     }
  //   }
  // }
}

enum HomeStatus { initial, busy, ready }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.notificationCount = 0,
    this.userAvatarImage = '',
    this.conditions = const [],
    this.petCategories = const [],
    this.newestPets = const [],
    this.nearestVets = const [],
  });

  final HomeStatus status;
  final int notificationCount;
  final String userAvatarImage;
  final List<ConditionModel> conditions;
  final List<CategoryModel> petCategories;
  final List<PetModel> newestPets;
  final List<VetModel> nearestVets;

  @override
  List<Object> get props => [
        status,
        notificationCount,
        userAvatarImage,
        conditions,
        petCategories,
        newestPets,
        nearestVets,
      ];

  HomeState copyWith({
    HomeStatus status,
    int notificationCount,
    String userAvatarImage,
    List<ConditionModel> conditions,
    List<CategoryModel> petCategories,
    List<PetModel> newestPets,
    List<VetModel> nearestVets,
  }) {
    return HomeState(
      status: status ?? this.status,
      notificationCount: notificationCount ?? this.notificationCount,
      userAvatarImage: userAvatarImage ?? this.userAvatarImage,
      conditions: conditions ?? this.conditions,
      petCategories: petCategories ?? this.petCategories,
      newestPets: newestPets ?? this.newestPets,
      nearestVets: nearestVets ?? this.nearestVets,
    );
  }
}
