import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cats/import.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({this.repo}) : super(const HomeState());

  final DatabaseRepository repo;

  Future<bool> load() async {
    var result = true;
    emit(state.copyWith(status: HomeStatus.busy));
    try {
      final int notificationCount = await repo.loadNotificationCount();
      final String userAvatarImage = await repo.loadUserAvatarImage();
      final List<PetCategory> petCategories = await repo.loadPetCategories();
      final List<Pet> newestPets = await repo.loadNewestPets();
      emit(state.copyWith(
        status: HomeStatus.ready,
        notificationCount: notificationCount,
        userAvatarImage: userAvatarImage,
        petCategories: petCategories,
        newestPets: newestPets,
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

  void clearNotification() {
    emit(state.copyWith(notificationCount: 0));
  }
}

enum HomeStatus { initial, busy, ready }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.notificationCount = 0,
    this.userAvatarImage = '',
    this.petCategories = const [],
    this.newestPets = const [],
  });

  final HomeStatus status;
  final int notificationCount;
  final String userAvatarImage;
  final List<PetCategory> petCategories;
  final List<Pet> newestPets;

  @override
  List<Object> get props => [
        status,
        notificationCount,
        userAvatarImage,
        petCategories,
        newestPets,
      ];

  HomeState copyWith({
    HomeStatus status,
    int notificationCount,
    String userAvatarImage,
    List<PetCategory> petCategories,
    List<Pet> newestPets,
  }) {
    return HomeState(
      status: status ?? this.status,
      notificationCount: notificationCount ?? this.notificationCount,
      userAvatarImage: userAvatarImage ?? this.userAvatarImage,
      petCategories: petCategories ?? this.petCategories,
      newestPets: newestPets ?? this.newestPets,
    );
  }
}
