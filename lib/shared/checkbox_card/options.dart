// options to display inside checkbox cards

class Options {
  // FILTERS========================================================================================================================================
  static const List<String> diet = [
    'balanced',
    'high-fiber',
    'high-protein',
    'low-carb',
    'low-fat',
    'low-sodium',
  ];
  static const List<String> mealType = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Teatime',
  ];
  static const List<String> cuisineType = [
    'American',
    'Asian',
    'British',
    'Caribbean',
    'Central Europe',
    'Chinese',
    'Eastern Europe',
    'French',
    'Indian',
    'Italian',
    'Japanese',
    'Korean',
    'Kosher',
    'Mediterranean',
    'Mexican',
    'Middle Eastern',
    'Nordic',
    'South American',
    'South East Asian',
  ];
  static const List<String> dishType = [
    'Biscuits and cookies',
    'Bread',
    'Cereals',
    'Condiments and sauces',
    'Desserts',
    'Drinks',
    'Main course',
    'Pancake',
    'Pasta',
    'Preps',
    'Preserve',
    'Salad',
    'Sandwiches',
    'Side dish',
    'Soup',
    'Starter',
    'Sweets',
  ];

  // USER PROFILE====================================================================================================================================
  static const List<String> dietaryPreferences = [
    'Keto-friendly',
    'Kosher',
    'Low-Potassium',
    'Low-sugar',
    'No-oil-added',
    'Paleo',
    'Pescatarian',
    'Sugar-conscious',
    'Vegan',
    'Vegetarian',
  ];
  static const List<String> allergies = [
    'Alcohol-free',
    'Celery-free',
    'Crustacean-free',
    'Dairy-free',
    'Egg-free',
    'Fish-free',
    'Gluten-free',
    'Mollusk-free',
    'Mustard-free',
    'Peanut-free',
    'Pork-free',
    'Red-meat-free',
    'Soy-free',
    'Wheat-free',
  ];
  static const List<String> nutrientTag1 = [
    'FAT', // total lipid (fat)
    'FASAT', // saturated
    'FATRN',
    'FAMS', // Fats, monounsaturated
    'FAPU',
    'CHOCDF', // carbohydrates
    'FIBTG', // fiber
    'SUGAR',
    'PROCNT',
  ];
  static const List<String> macronutrients = [
    'Fat',
    'Saturated',
    'Trans',
    'Monounsaturated',
    'Polyunsaturated',
    'Carbs',
    'Fiber',
    'Sugars',
    'Protein',
  ];
  static const List<String> nutrientTag2 = [
    'CHOLE',
    'CA',
    'FE',
    'FOLDFE',
    'MG',
    'NIA',
    'P',
    'K',
    'RIBF',
    'THIA',
    'NA',
    'VITA_RAE',
    'VITB6A',
    'VITB12',
    'VITC',
    'VITD',
    'TOPCHA',
    'VITK1'
  ];
  static const List<String> micronutrients = [
    'Cholesterol',
    'Calcium',
    'Iron',
    'Folate',
    'Magnesium',
    'Niacin (B3)',
    'Phosphorus',
    'Potassium',
    'Riboflavin (B2)',
    'Thiamin (B1)',
    'Sodium',
    'Vitamin A',
    'Vitamin B6',
    'Vitamin B12',
    'Vitamin C',
    'Vitamin D',
    'Vitamin E',
    'Vitamin K'
  ];

  // INFO TEXTS=====================================================================================================================================
  static const List<String> dietInfoText = [
    'Protein/Fat/Carb values in 15/35/50 ratio',
    'More than 5g fiber per serving',
    'More than 50% of total calories from proteins',
    'Less than 20% of total calories from carbs',
    'Less than 15% of total calories from fat',
    'Less than 140mg sodium per serving'
  ];
  static const List<String> dietaryPreferencesInfoText = [
    'Maximum 7 grams of net carbs per serving.',
    'Contains only ingredients allowed by the kosher diet. However it does not guarantee kosher preparation of the ingredients themselves.',
    'Less than 150mg per serving.',
    'No simple sugars – glucose, dextrose, galactose, fructose, sucrose, lactose, maltose.',
    'No oil added except to what is contained in the basic ingredients',
    'Excludes what are perceived to be agricultural products; grains, legumes, dairy products, potatoes, refined salt, refined sugar, and processed oils.',
    'Does not contain meat or meat based products, can contain dairy and fish.',
    'Less than 4g of sugar per serving.',
    'No meat, poultry, fish, dairy, eggs or honey.',
    'No meat, poultry, or fish.',
  ];
  static const List<String> allergiesInfoText = [
    'No alcohol used or contained.',
    'Does not contain celery or derivatives.',
    'Does not contain crustaceans (shrimp, lobster etc.) or derivatives.',
    'No dairy; no lactose.',
    'No eggs or products containing eggs.',
    'No fish or fish derivatives.',
    'No ingredients containing gluten.',
    'No mollusks',
    'Does not contain mustard or derivatives.',
    'No peanuts or products containing peanuts.',
    'Does not contain pork or derivatives,',
    'Does not contain beef, lamb, pork, duck, goose, game, horse, and other types of red meat or products containing red meat.',
    'No soy or products containing soy.',
    'No wheat, can have gluten though.',
  ];

  // INGREDIENTS====================================================================================================================================
  static const List<String> pantryEssentials = [
    'Baking powder',
    'Baking soda',
    'Butter',
    'Coconut milk',
    'Cooking oil',
    'Egg',
    'Flour',
    'Garlic',
    'Honey',
    'Olive oil',
    'Onion',
    'Mayonnaise',
    'Milk',
    'Paprika',
    'Soy Sauce',
    'Sugar',
    'Vanilla',
    'Vegetable oil',
  ];
  static const List<String> meat = [
    'Bacon',
    'Bacon bits',
    'Beef sirloin',
    'Brisket',
    'Ground beef',
    'Ground pork',
    'Pork belly',
    'Pork chops',
    'Pork fillet',
    'Pork loin',
    'Pork ribs',
    'Pork shoulder',
    'Roast beef',
    'Salami',
  ];
  static const List<String> fishAndPoultry = [
    'Bangus',
    'Chicken breast',
    'Chicken leg',
    'Chicken thighs',
    'Chicken wings',
    'Fish fillet',
    'Ground chicken',
    'Ground turkey',
    'Salmon',
    'Sardines',
    'Tilapia',
    'Tuna',
    'Whole chicken',
  ];
  static const List<String> vegetablesAndGreens = [
    'Avocado',
    'Bell pepper',
    'Broccoli',
    'Cabbage',
    'Carrot',
    'Cauliflower',
    'Celery',
    'Eggplant',
    'Lettuce',
    'Potato',
    'Pumpkin',
    'Radish',
    'Spinach',
    'Tomato',
  ];
  static const List<String> baking = [
    'Buttermilk',
    'Cornstarch',
    'Cream',
    'Chocolate chips',
    'Condensed milk',
    'Heavy cream',
    'Margarine',
    'Milk powder',
    'Shortening',
    'Whipped cream',
    'Yeast',
  ];
}
