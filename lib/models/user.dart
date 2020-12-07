import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

@CopyWith()
class UserModel extends Equatable {
  const UserModel({
    this.id,
    this.displayName,
    this.photoURL,
  });

  final String id;
  final String displayName;
  final String photoURL;

  // Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    id: '',
  );

  @override
  List<Object> get props => [
        id,
        displayName,
        photoURL,
      ];
}
