// Seeded photos for demo recipes.
export const recipeImages = {
  '30000000-0000-0000-0000-000000000001': 'https://leitesculinaria.com/wp-content/uploads/2024/04/spaghetti-carbonara-1-2.jpg',
  '30000000-0000-0000-0000-000000000002': 'https://images.unsplash.com/photo-1554520735-0a6b8b6ce8b7?w=700&auto=format&fit=crop&q=75',
  '30000000-0000-0000-0000-000000000003': 'https://cdn.loveandlemons.com/wp-content/uploads/2024/12/caesar-salad-recipe.jpg',
  '30000000-0000-0000-0000-000000000004': 'https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2021/05/Chicken-Stir-Fry-6.jpg',
  '30000000-0000-0000-0000-000000000005': 'https://mallorythedietitian.com/wp-content/uploads/2024/05/smashed-avocado-toast-with-egg-and-red-pepper-flakes.jpg',
  '30000000-0000-0000-0000-000000000006': 'https://foodbyjonister.com/wp-content/uploads/2017/07/IMG_5346.jpg',
  '30000000-0000-0000-0000-000000000007': 'https://hips.hearstapps.com/hmg-prod/images/greek-salad-lead-642f29241cceb.jpg?crop=1xw:1xh;center,top&resize=640:*',
  '30000000-0000-0000-0000-000000000008': 'https://bakingamoment.com/wp-content/uploads/2016/09/IMG_0316-chocolate-chip-cookies-1.jpg',
  '30000000-0000-0000-0000-000000000009': 'https://www.thespruceeats.com/thmb/XIgSQII8U_NsrzxBQ1QDc6siZ08=/750x0/filters:no_upscale():max_bytes(150000):strip_icc()/classic-french-omelet-recipe-1375522-hero-01-da0b2c6b285642038d0f0323adcf26b5.jpg',
  '30000000-0000-0000-0000-000000000010': 'https://aflavorfulbite.com/wp-content/uploads/2025/10/crispy-ground-beef-tacos-900x1200-1.jpg',
  '30000000-0000-0000-0000-000000000011': 'https://heavenlyhomecooking.com/wp-content/uploads/2022/03/Banana-Smoothie-Bowl-Recipe-Finished-1.jpg',
  '30000000-0000-0000-0000-000000000012': 'https://savorthebest.com/wp-content/uploads/2024/04/garlic-butter-rice-5.jpg'
}

// Priority: 1) hard-coded demo image  2) thumbnail column from DB  3) null (shows gradient fallback)
export function getRecipeImageUrl(recipe) {
  if (!recipe) return null
  if (recipeImages[recipe.recipe_id]) return recipeImages[recipe.recipe_id]
  return recipe.thumbnail ?? null
}
