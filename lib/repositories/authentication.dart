import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_pet/import.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  Future<String> getIdToken({bool forceRefresh}) {
    // out('AuthenticationRepository: getIdToken()');
    return _firebaseAuth.currentUser?.getIdToken(forceRefresh);
  }

  Future<void> setUserIdFromToken(Future<IdTokenResult> tokenResult) async {
    await tokenResult;
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<UserModel> get userChanges {
    return _firebaseAuth.authStateChanges().map((User firebaseUser) {
      out('AUTH_REPO userChanges()');
      if (firebaseUser == null) {
        _currentUser = UserModel.empty;
      } else {
        _currentUser = firebaseUser.toUserModel;
        setHasuraUserId();
      }
      return _currentUser;
    });
  }

  void setHasuraUserId() {
    if (_firebaseAuth.currentUser != null) {
      _firebaseAuth.currentUser.getIdTokenResult().then((tokenResult) {
        // out('tokenResult = ${tokenResult.claims}');
        final String hasuraUserId =
            tokenResult.claims['https://hasura.io/jwt/claims']
                ['x-hasura-user-id'] as String;
        // out('hasuraUserId = $hasuraUserId');
        _currentUser = _currentUser.copyWith(id: hasuraUserId);
        out('AUTH_REPO _currentUser.id = ${_currentUser.id}');
      });
    }
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
    } catch (error) {
      rethrow;
      // throw LogInWithGoogleFailure();
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
    } catch (error) {
      rethrow;
      // throw LogOutFailure();
    }
  }
}

extension on User {
  UserModel get toUserModel {
    return UserModel(
      id: uid,
      name: displayName,
      photo: photoURL,
      email: email,
      phone: phoneNumber,
    );
  }
}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}
