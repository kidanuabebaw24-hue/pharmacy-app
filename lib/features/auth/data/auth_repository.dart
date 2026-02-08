import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_app/features/auth/domain/user_model.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
}

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password, String name, UserRole role) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    
    if (user != null) {
      final appUser = AppUser(
        id: user.uid,
        email: email,
        name: name,
        role: role,
      );
      
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
    }
  }

  Future<AppUser?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;
    
    return AppUser.fromMap(doc.data()!, doc.id);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
