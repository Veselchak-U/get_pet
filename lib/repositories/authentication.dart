import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_pet/import.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<UserModel> get userChanges {
    return _firebaseAuth.authStateChanges().map((User firebaseUser) {
      return firebaseUser == null ? UserModel.empty : firebaseUser.toUserModel;
    });
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

/// Signs out the current user which will emit
  /// [User.empty] from the [userChanges] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on User {
  UserModel get toUserModel {
    return UserModel(id: uid, displayName: displayName, photoURL: photoURL);
  }
}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}
