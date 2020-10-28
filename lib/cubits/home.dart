import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cats/import.dart';
import 'package:flutter/material.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<bool> load() async {
    var result = true;
    emit(state.copyWith(status: HomeStatus.busy));
    try {
      final int notificationCount = 2;
      final String userAvatarImage =
          'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80';
      final List<PetCategory> petCategories = [
        PetCategory(
          name: 'Hamster',
          count: 56,
          image: 'assets/image/hamster.png',
          background: Color(0xffF9EDD3),
        ),
        PetCategory(
          name: 'Cats',
          count: 210,
          image: 'assets/image/cat.png',
          background: Color(0xffD8F1FD),
        ),
        PetCategory(
          name: 'Bunnies',
          count: 90,
          image: 'assets/image/rabbit.png',
          background: Color(0xffE6F3E7),
        ),
        PetCategory(
          name: 'Dogs',
          count: 340,
          image: 'assets/image/dog.png',
          background: Color(0xffFAE0D8),
        ),
      ];
      final List<Pet> newestPets = [];

      await Future.delayed(const Duration(milliseconds: 1000));
      emit(state.copyWith(
        status: HomeStatus.ready,
        notificationCount: notificationCount,
        userAvatarImage: userAvatarImage,
        petCategories: petCategories,
        newestPets: newestPets,
      ));
    } catch (error) {
      result = false;
    }
    return result;
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
