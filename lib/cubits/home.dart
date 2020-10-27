import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
}

enum HomeStateStatus { q, w }


class HomeState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}