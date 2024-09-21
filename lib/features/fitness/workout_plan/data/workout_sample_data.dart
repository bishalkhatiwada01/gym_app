class Exercise {
  final String name;
  final String instruction;
  final int sets;
  final int reps;
  final Duration duration;
  final double caloriesPerMinute;

  Exercise({
    required this.name,
    required this.instruction,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.caloriesPerMinute,
  });

  double get totalCalories => (duration.inMinutes * caloriesPerMinute) * sets;
}

class DailyWorkout {
  final String day;
  final List<Exercise> exercises;
  final String focusArea;

  DailyWorkout(
      {required this.day, required this.exercises, required this.focusArea});

  double get totalCalories =>
      exercises.fold(0, (sum, exercise) => sum + exercise.totalCalories);
}

Map<String, List<Exercise>> sampleExercises = {
  'Cardio': [
    Exercise(
      name: 'Jumping Jacks',
      instruction:
          'Start with your feet together and arms at your sides, then jump and spread your legs while raising your arms above your head.',
      sets: 3,
      reps: 20,
      duration: const Duration(seconds: 30),
      caloriesPerMinute: 10, // Updated
    ),
    Exercise(
      name: 'Mountain Climbers',
      instruction:
          'Start in a plank position and alternately bring your knees towards your chest in a running motion.',
      sets: 3,
      reps: 15,
      duration: const Duration(seconds: 45),
      caloriesPerMinute: 12, // Updated
    ),
    Exercise(
      name: 'Burpees',
      instruction:
          'Start standing, drop into a squat, kick your legs back into a plank, do a push-up, jump your feet back to your hands, and jump up with arms raised.',
      sets: 3,
      reps: 10,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 14, // Updated
    ),
    Exercise(
      name: 'High Knees',
      instruction: 'Run in place, lifting your knees high towards your chest.',
      sets: 3,
      reps: 30,
      duration: const Duration(seconds: 45),
      caloriesPerMinute: 11, // Updated
    ),
  ],
  'Upper Body': [
    Exercise(
      name: 'Push-ups',
      instruction:
          'Start in a plank position, lower your body until your chest nearly touches the floor, then push back up.',
      sets: 3,
      reps: 12,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 8, // Updated
    ),
    Exercise(
      name: 'Dumbbell Rows',
      instruction:
          'Bend at the waist with a dumbbell in one hand, pull the weight up to your side, then lower it back down.',
      sets: 3,
      reps: 10,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 7, // Updated
    ),
    Exercise(
      name: 'Tricep Dips',
      instruction:
          'Using parallel bars or a sturdy chair, lower your body by bending your elbows, then push back up.',
      sets: 3,
      reps: 12,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 6, // Updated
    ),
    Exercise(
      name: 'Shoulder Press',
      instruction:
          'Hold dumbbells at shoulder height, then press them overhead until your arms are fully extended.',
      sets: 3,
      reps: 10,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 7, // Updated
    ),
  ],
  'Lower Body': [
    Exercise(
      name: 'Squats',
      instruction:
          'Stand with feet shoulder-width apart, lower your body as if sitting back into a chair, then return to standing.',
      sets: 4,
      reps: 15,
      duration: const Duration(seconds: 90),
      caloriesPerMinute: 9, // Updated
    ),
    Exercise(
      name: 'Lunges',
      instruction:
          'Step forward with one leg, lowering your hips until both knees are bent at about 90-degree angles.',
      sets: 3,
      reps: 12,
      duration: const Duration(seconds: 90),
      caloriesPerMinute: 8, // Updated
    ),
    Exercise(
      name: 'Glute Bridges',
      instruction:
          'Lie on your back with knees bent, lift your hips off the ground, squeezing your glutes at the top.',
      sets: 3,
      reps: 15,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 5, // Corrected, already reasonable
    ),
    Exercise(
      name: 'Calf Raises',
      instruction:
          'Stand with feet hip-width apart, raise your heels off the ground, then lower them back down.',
      sets: 3,
      reps: 20,
      duration: const Duration(seconds: 45),
      caloriesPerMinute: 4, // Corrected, already reasonable
    ),
  ],
  'Core': [
    Exercise(
      name: 'Plank',
      instruction:
          'Hold a push-up position with your forearms on the ground, keeping your body in a straight line.',
      sets: 3,
      reps: 1,
      duration: const Duration(seconds: 30),
      caloriesPerMinute: 5, // Updated
    ),
    Exercise(
      name: 'Russian Twists',
      instruction:
          'Sit with knees bent and feet off the ground, twist your torso from side to side.',
      sets: 3,
      reps: 20,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 8, // Updated
    ),
    Exercise(
      name: 'Leg Raises',
      instruction:
          'Lie on your back with legs straight, lift them up to a 90-degree angle, then lower them back down.',
      sets: 3,
      reps: 15,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 6, // Updated
    ),
    Exercise(
      name: 'Bicycle Crunches',
      instruction:
          'Lie on your back, lift shoulders off the ground, and alternate bringing opposite elbow to knee.',
      sets: 3,
      reps: 20,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 9, // Updated
    ),
  ],
  'Flexibility': [
    Exercise(
      name: 'Standing Quad Stretch',
      instruction:
          'Stand on one leg, bring your other heel towards your buttocks, and hold your foot with your hand.',
      sets: 2,
      reps: 1,
      duration: const Duration(seconds: 30),
      caloriesPerMinute: 3, // Updated
    ),
    Exercise(
      name: 'Seated Forward Bend',
      instruction:
          'Sit with legs extended, reach forward towards your toes, keeping your back straight.',
      sets: 2,
      reps: 1,
      duration: const Duration(seconds: 30),
      caloriesPerMinute: 3, // Updated
    ),
    Exercise(
      name: 'Cat-Cow Stretch',
      instruction:
          'Start on hands and knees, alternate between arching your back (cow) and rounding it (cat).',
      sets: 2,
      reps: 10,
      duration: const Duration(seconds: 60),
      caloriesPerMinute: 4, // Updated
    ),
    Exercise(
      name: 'Child\'s Pose',
      instruction:
          'Kneel on the floor, sit back on your heels, and stretch your arms forward on the ground.',
      sets: 2,
      reps: 1,
      duration: const Duration(seconds: 30),
      caloriesPerMinute: 3, // Updated
    ),
  ],
};

List<String> workoutFocusAreas = [
  'Cardio',
  'Upper Body',
  'Lower Body',
  'Core',
  'Flexibility'
];
