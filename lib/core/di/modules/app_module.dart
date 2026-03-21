import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

/// Registers third-party / framework objects that cannot be annotated
/// directly with [@injectable].
@module
abstract class AppModule {
  /// Singleton Firestore instance – shared across all repositories.
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Singleton FirebaseAuth instance – used by HomeCubit to get current user.
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}
