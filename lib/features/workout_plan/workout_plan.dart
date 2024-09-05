class WorkoutPlan {
  final String name;
  final String target;
  final String goal;
  final List<String> schedule;

  WorkoutPlan({
    required this.name,
    required this.target,
    required this.goal,
    required this.schedule,
  });
}

final List<WorkoutPlan> workoutPlans = [
  WorkoutPlan(
    name: "Weight Loss Beginner",
    target: "Beginners",
    goal: "Lose weight",
    schedule: [
      "Monday: 30-minute brisk walk",
      "Tuesday: 20-minute aerobics",
      "Wednesday: 30-minute yoga",
      "Thursday: 30-minute swim",
      "Friday: 30-minute bodyweight exercises",
      "Saturday: Rest or stretching",
      "Sunday: 30-minute light activity",
    ],
  ),
  WorkoutPlan(
    name: "Muscle Gain Intermediate",
    target: "Intermediates",
    goal: "Build muscle",
    schedule: [
      "Monday: Upper body strength",
      "Tuesday: Lower body strength",
      "Wednesday: Rest or light cardio",
      "Thursday: Full body strength",
      "Friday: Core exercises",
      "Saturday: HIIT",
      "Sunday: Rest",
    ],
  ),
  WorkoutPlan(
    name: "Senior Fitness",
    target: "Seniors",
    goal: "Stay active",
    schedule: [
      "Monday: 20-minute yoga",
      "Tuesday: Chair exercises",
      "Wednesday: Water aerobics",
      "Thursday: 20-minute walk",
      "Friday: Balance exercises",
      "Saturday: Stretching",
      "Sunday: Light activity",
    ],
  ),
  WorkoutPlan(
    name: "HIIT Fat Burn",
    target: "Advanced",
    goal: "Burn fat",
    schedule: [
      "Monday: 30-minute HIIT",
      "Tuesday: Sprint intervals",
      "Wednesday: Strength training",
      "Thursday: 30-minute HIIT",
      "Friday: Cardio",
      "Saturday: Full body workout",
      "Sunday: Rest",
    ],
  ),
  WorkoutPlan(
    name: "Flexibility & Yoga",
    target: "All levels",
    goal: "Improve flexibility",
    schedule: [
      "Monday: Gentle yoga (30 minutes)",
      "Tuesday: Stretching (20 minutes)",
      "Wednesday: Balance exercises",
      "Thursday: Yoga (20 minutes)",
      "Friday: Meditation",
      "Saturday: Stretching",
      "Sunday: Rest",
    ],
  ),
];

WorkoutPlan selectWorkoutPlan(Map<String, dynamic> userData) {
  double bmi = calculateBMI(
      double.parse(userData['weight']), double.parse(userData['height']));
  int age = int.parse(userData['age']);
  String gender = userData['gender'];
  String activityLevel = userData['activityLevel'];
  String fitnessGoal = userData['fitnessGoal'];

  Map<String, int> planScores = {};
  for (var plan in workoutPlans) {
    planScores[plan.name] = 0;
  }

  void incrementScore(String planName, int increment) {
    planScores[planName] = (planScores[planName] ?? 0) + increment;
  }

  // BMI considerations
  if (bmi < 18.5) {
    incrementScore("Muscle Building for Intermediates", 2);
    incrementScore("Weight Gain for Underweight Individuals", 3);
  } else if (bmi >= 18.5 && bmi < 25) {
    incrementScore("Functional Fitness for Busy Professionals", 2);
    incrementScore("Muscle Building for Intermediates", 2);
  } else if (bmi >= 25 && bmi < 30) {
    incrementScore("Weight Loss for Beginners", 2);
    incrementScore("High-Intensity Fat Burning", 2);
  } else {
    incrementScore("Weight Loss for Beginners", 3);
  }

  // Age considerations
  if (age < 30) {
    incrementScore("High-Intensity Fat Burning", 2);
    incrementScore("Muscle Building for Intermediates", 2);
  } else if (age >= 30 && age < 50) {
    incrementScore("Functional Fitness for Busy Professionals", 2);
  } else if (age >= 50 && age < 65) {
    incrementScore("Low-Impact Fitness for Seniors", 2);
  } else {
    incrementScore("Staying Fit for Seniors", 3);
  }

  // Gender considerations (if there are gender-specific plans)
  if (gender == "Female") {
    incrementScore("Women's Strength Training", 2);
  } else if (gender == "Male") {
    incrementScore("Men's Muscle Building", 2);
  }

  // Activity level considerations
  switch (activityLevel) {
    case "Sedentary":
      incrementScore("Weight Loss for Beginners", 2);
      break;
    case "Moderately Active":
      incrementScore("Functional Fitness for Busy Professionals", 2);
      break;
    case "Very Active":
      incrementScore("High-Intensity Fat Burning", 2);
      incrementScore("Advanced Athlete Training", 3);
      break;
  }

  // Fitness goal considerations
  switch (fitnessGoal) {
    case "Lose Weight":
      incrementScore("Weight Loss for Beginners", 3);
      incrementScore("High-Intensity Fat Burning", 3);
      break;
    case "Build Muscle":
      incrementScore("Muscle Building for Intermediates", 3);
      incrementScore("Advanced Strength Training", 2);
      break;
    case "Stay Fit":
      incrementScore("Functional Fitness for Busy Professionals", 3);
      incrementScore("Balanced Fitness Routine", 2);
      break;
    case "Improve Flexibility":
      incrementScore("Yoga and Flexibility Training", 3);
      break;
    case "Increase Endurance":
      incrementScore("Endurance Athlete Program", 3);
      break;
  }

  // Special considerations
  if (bmi > 30 &&
      activityLevel == "Sedentary" &&
      fitnessGoal == "Lose Weight") {
    incrementScore("Gradual Weight Loss for Obese Individuals", 5);
  }

  if (age > 60 && fitnessGoal == "Stay Fit") {
    incrementScore("Staying Fit for Seniors", 5);
  }

  // Select the plan with the highest score
  String selectedPlanName =
      planScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;

  return workoutPlans.firstWhere(
    (plan) => plan.name == selectedPlanName,
    orElse: () => workoutPlans.firstWhere(
        (plan) => plan.name == "Functional Fitness for Busy Professionals"),
  );
}

double calculateBMI(double weightKg, double heightCm) {
  double heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

// Helper function to get BMI category
String getBMICategory(double bmi) {
  if (bmi < 18.5) return "Underweight";
  if (bmi >= 18.5 && bmi < 25) return "Normal";
  if (bmi >= 25 && bmi < 30) return "Overweight";
  return "Obese";
}
