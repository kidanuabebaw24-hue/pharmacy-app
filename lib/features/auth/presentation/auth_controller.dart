import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../domain/user_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // nothing to initialize
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signIn(email, password));
  }

  Future<void> register(String email, String password, String name, UserRole role) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).register(email, password, name, role));
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signOut());
  }
}
