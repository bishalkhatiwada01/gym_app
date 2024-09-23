import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/features/fitness/common/user_model.dart';

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  void updateProfile(UserProfile profile) {
    state = profile;
  }

  void updateAge(int age) {
    if (state != null) {
      state = UserProfile(
        age: age,
        weight: state!.weight,
        height: state!.height,
        fitnessLevel: state!.fitnessLevel,
        goal: state!.goal,
        gender: state!.gender,
        targetWeight: state!.targetWeight,
      );
    }
  }

  void updateWeight(double weight) {
    if (state != null) {
      state = UserProfile(
        age: state!.age,
        weight: weight,
        height: state!.height,
        fitnessLevel: state!.fitnessLevel,
        goal: state!.goal,
        gender: state!.gender,
        targetWeight: state!.targetWeight,
      );
    }
  }

  // Add similar methods for updating other properties...

  void clearProfile() {
    state = null;
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});
