import 'dart:math';
import 'package:gymapp/features/fitness/common/user_model.dart';

class DietRecommendation {
  final UserProfile userProfile;
  late int dailyCalories;
  late Map<String, double> macronutrients;
  late Map<String, int> mealCalories;

  DietRecommendation(this.userProfile) {
    _calculateDailyCalories();
    _calculateMacronutrients();
    _distributeMealCalories();
  }

  void _calculateDailyCalories() {
    // Basic BMR calculation using Harris-Benedict Equation
    double bmr;
    if (userProfile.gender == 'Male') {
      bmr = 88.362 +
          (13.397 * userProfile.weight) +
          (4.799 * userProfile.height) -
          (5.677 * userProfile.age);
    } else {
      bmr = 447.593 +
          (9.247 * userProfile.weight) +
          (3.098 * userProfile.height) -
          (4.330 * userProfile.age);
    }

    // Activity factor
    double activityFactor;
    switch (userProfile.fitnessLevel) {
      case 'Beginner':
        activityFactor = 1.2;
        break;
      case 'Intermediate':
        activityFactor = 1.375;
        break;
      case 'Advanced':
        activityFactor = 1.55;
        break;
      default:
        activityFactor = 1.2;
    }

    dailyCalories = (bmr * activityFactor).round();

    // Adjust calories based on goal
    switch (userProfile.goal) {
      case 'Weight Loss':
        dailyCalories = (dailyCalories * 0.85).round(); // 15% calorie deficit
        break;
      case 'Muscle Gain':
        dailyCalories = (dailyCalories * 1.1).round(); // 10% calorie surplus
        break;
      case 'General Fitness':
        // No adjustment needed
        break;
    }
  }

  void _calculateMacronutrients() {
    switch (userProfile.goal) {
      case 'Weight Loss':
        macronutrients = {
          'protein': dailyCalories * 0.30 / 4,
          'carbs': dailyCalories * 0.40 / 4,
          'fats': dailyCalories * 0.30 / 9,
        };
        break;
      case 'Muscle Gain':
        macronutrients = {
          'protein': dailyCalories * 0.30 / 4,
          'carbs': dailyCalories * 0.50 / 4,
          'fats': dailyCalories * 0.20 / 9,
        };
        break;
      case 'General Fitness':
        macronutrients = {
          'protein': dailyCalories * 0.25 / 4,
          'carbs': dailyCalories * 0.55 / 4,
          'fats': dailyCalories * 0.20 / 9,
        };
        break;
    }
  }

  void _distributeMealCalories() {
    mealCalories = {
      'Breakfast': (dailyCalories * 0.25).round(),
      'Morning Snack': (dailyCalories * 0.10).round(),
      'Lunch': (dailyCalories * 0.30).round(),
      'Afternoon Snack': (dailyCalories * 0.10).round(),
      'Dinner': (dailyCalories * 0.25).round(),
    };
  }

  List<Map<String, dynamic>> generateWeeklyMealPlan() {
    List<Map<String, dynamic>> weeklyPlan = [];
    List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    for (String day in daysOfWeek) {
      weeklyPlan.add({
        'day': day,
        'meals': _generateDailyMealPlan(),
      });
    }

    return weeklyPlan;
  }

  List<Map<String, dynamic>> _generateDailyMealPlan() {
    List<Map<String, dynamic>> breakfastOptions = [
      {
        'name': 'Oatmeal with milk and fruits',
        'ingredients': [
          '1 cup oatmeal',
          '1 cup low-fat milk',
          '1 medium banana, sliced',
          '1 tbsp honey',
          '1 tbsp chopped nuts'
        ],
        'instructions':
            'Cook oatmeal with milk, top with banana slices, drizzle with honey, and sprinkle chopped nuts.'
      },
      {
        'name': 'Nepali style omelette with vegetables',
        'ingredients': [
          '2 eggs',
          '1/4 cup chopped mixed vegetables (tomato, onion, capsicum)',
          '1 tsp oil',
          '2 whole wheat rotis'
        ],
        'instructions':
            'Beat eggs with vegetables, cook in oil. Serve with rotis.'
      },
      {
        'name': 'Dhido with vegetable curry',
        'ingredients': [
          '1 cup buckwheat flour',
          '1 cup mixed vegetable curry',
          '1/2 cup yogurt'
        ],
        'instructions':
            'Cook dhido, serve with vegetable curry and a side of yogurt.'
      },
      {
        'name': 'Sel roti with yogurt and fruits',
        'ingredients': [
          '2 sel rotis',
          '1/2 cup yogurt',
          '1 cup mixed fruits (apple, pomegranate, guava)'
        ],
        'instructions': 'Serve sel roti with a side of yogurt and mixed fruits.'
      },
      {
        'name': 'Sattu paratha with mint chutney',
        'ingredients': [
          '2 sattu parathas',
          '2 tbsp mint chutney',
          '1/2 cup yogurt'
        ],
        'instructions':
            'Cook sattu parathas, serve with mint chutney and a side of yogurt.'
      },
    ];

    List<Map<String, dynamic>> lunchOptions = [
      {
        'name': 'Dal bhat with chicken curry and vegetables',
        'ingredients': [
          '1 cup cooked brown rice',
          '1/2 cup dal',
          '100g chicken curry',
          '1 cup mixed vegetable curry',
          '1 small piece of pickle'
        ],
        'instructions':
            'Serve rice with dal, chicken curry, vegetable curry, and pickle on the side.'
      },
      {
        'name': 'Vegetable pulao with yogurt',
        'ingredients': [
          '1 cup mixed vegetable pulao',
          '1/2 cup yogurt',
          '1 small piece of pickle'
        ],
        'instructions':
            'Serve vegetable pulao with a side of yogurt and pickle.'
      },
      {
        'name': 'Whole grain chapati with lentil curry and vegetables',
        'ingredients': [
          '2 whole grain chapatis',
          '1/2 cup lentil curry',
          '1 cup mixed vegetable curry'
        ],
        'instructions': 'Serve chapatis with lentil curry and vegetable curry.'
      },
      {
        'name': 'Nepali style thukpa with vegetables',
        'ingredients': [
          '1 bowl thukpa with mixed vegetables',
          '1 boiled egg',
          '1 small piece of pickle'
        ],
        'instructions':
            'Serve hot thukpa with a boiled egg and pickle on the side.'
      },
      {
        'name': 'Quinoa salad with grilled tofu and vegetables',
        'ingredients': [
          '1 cup cooked quinoa',
          '100g grilled tofu',
          '1 cup mixed vegetables (cucumber, tomato, bell peppers)',
          '1 tbsp olive oil dressing'
        ],
        'instructions':
            'Mix quinoa with grilled tofu and vegetables, dress with olive oil.'
      },
    ];

    List<Map<String, dynamic>> dinnerOptions = [
      {
        'name': 'Grilled fish with brown rice and stir-fried vegetables',
        'ingredients': [
          '150g grilled fish',
          '1/2 cup cooked brown rice',
          '1 cup stir-fried mixed vegetables',
          '1 tsp oil for cooking'
        ],
        'instructions':
            'Grill fish, cook brown rice, and stir-fry vegetables. Serve together.'
      },
      {
        'name': 'Lentil soup with whole grain bread and salad',
        'ingredients': [
          '1 cup lentil soup',
          '2 slices whole grain bread',
          '1 cup mixed green salad',
          '1 tbsp low-fat dressing'
        ],
        'instructions':
            'Serve lentil soup with bread on the side. Toss salad with dressing.'
      },
      {
        'name': 'Nepali style chickpea curry with brown rice',
        'ingredients': [
          '1 cup chickpea curry',
          '1/2 cup cooked brown rice',
          '1/2 cup yogurt',
          '1 small piece of pickle'
        ],
        'instructions':
            'Serve chickpea curry over brown rice with a side of yogurt and pickle.'
      },
      {
        'name': 'Vegetable momos with tomato soup',
        'ingredients': [
          '6 vegetable momos',
          '1 cup tomato soup',
          '2 tbsp momo sauce'
        ],
        'instructions':
            'Steam momos and serve with hot tomato soup and momo sauce.'
      },
      {
        'name': 'Baked sweet potato with black bean curry',
        'ingredients': [
          '1 medium baked sweet potato',
          '1/2 cup black bean curry',
          '1/4 cup yogurt',
          '1 tbsp chopped cilantro'
        ],
        'instructions':
            'Top baked sweet potato with black bean curry, yogurt, and cilantro.'
      },
    ];

    List<Map<String, dynamic>> snackOptions = [
      {
        'name': 'Mixed nuts and dried fruits',
        'ingredients': ['1/4 cup mixed nuts and dried fruits'],
        'instructions':
            'Mix equal parts of almonds, walnuts, raisins, and dried apricots.'
      },
      {
        'name': 'Sliced cucumber with hummus',
        'ingredients': ['1 medium cucumber, sliced', '2 tbsp hummus'],
        'instructions': 'Serve cucumber slices with hummus for dipping.'
      },
      {
        'name': 'Yogurt with berries',
        'ingredients': [
          '1 cup low-fat yogurt',
          '1/2 cup mixed berries',
          '1 tsp honey'
        ],
        'instructions': 'Top yogurt with berries and drizzle with honey.'
      },
      {
        'name': 'Roasted chickpeas',
        'ingredients': [
          '1/2 cup roasted chickpeas',
          '1 tsp olive oil',
          'Spices (cumin, coriander, salt)'
        ],
        'instructions':
            'Toss chickpeas with oil and spices, roast until crispy.'
      },
      {
        'name': 'Apple slices with peanut butter',
        'ingredients': ['1 medium apple, sliced', '1 tbsp peanut butter'],
        'instructions': 'Serve apple slices with peanut butter for dipping.'
      },
    ];

    Random random = Random();

    return [
      {
        'meal': 'Breakfast',
        'calories': mealCalories['Breakfast'],
        ...breakfastOptions[random.nextInt(breakfastOptions.length)]
      },
      {
        'meal': 'Morning Snack',
        'calories': mealCalories['Morning Snack'],
        ...snackOptions[random.nextInt(snackOptions.length)]
      },
      {
        'meal': 'Lunch',
        'calories': mealCalories['Lunch'],
        ...lunchOptions[random.nextInt(lunchOptions.length)]
      },
      {
        'meal': 'Afternoon Snack',
        'calories': mealCalories['Afternoon Snack'],
        ...snackOptions[random.nextInt(snackOptions.length)]
      },
      {
        'meal': 'Dinner',
        'calories': mealCalories['Dinner'],
        ...dinnerOptions[random.nextInt(dinnerOptions.length)]
      },
    ];
  }

  List<String> generateNutritionalTips() {
    return [
      'Incorporate local vegetables like spinach, mustard greens, and bitter gourd for added nutrients.',
      "Use mustard oil in moderation for cooking, as it's rich in monounsaturated fatty acids.",
      "Include lentils (dal) in your daily diet as they're an excellent source of plant-based protein.",
      'Opt for whole grains like brown rice or millet instead of white rice when possible.',
      'Stay hydrated with water and try herbal teas like ginger tea for added health benefits.',
      "Include curd (dahi) in your diet as it's a good source of probiotics.",
      'Spices like turmeric, cumin, and coriander not only add flavor but also have health benefits.',
      'Snack on locally available fruits like guava, papaya, and pomegranate for vitamins and fiber.',
      'Try to include a variety of colorful vegetables in your meals for a range of nutrients.',
      'Consider adding flaxseeds or chia seeds to your meals for omega-3 fatty acids.',
      'Limit the consumption of processed and fried foods for better health.',
      'Practice portion control even with healthy foods to maintain calorie balance.',
      'Try to include fish in your diet at least twice a week for heart-healthy omega-3 fats.',
    ];
  }
}
