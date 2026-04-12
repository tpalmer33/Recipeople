-- ==================================================================
-- Recipeople — Seed Data (uses real Supabase Auth UUIDs)
-- Paste into the SQL Editor and click Run.
--
-- Real auth UUID → profile mapping:
--   aa@gmail.com  6760a043-18db-4900-8b56-f59b0fa41127  → Angel  A
--   ay@gmail.com  6f3ed32e-1608-4aaf-8ead-140bba81ad71  → Andrew Y
--   hk@gmail.com  e52d29a0-c08d-4bbf-a861-959f04648417  → Hasmika K
--   na@gmail.com  91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec  → Neo A
--   tp@gmail.com  1b62830f-00bf-4f78-aad6-e44d02030106  → Trey P
--
-- public.users rows already exist (created by fix_missing_profiles.sql).
-- This script only UPDATES the placeholder names, then seeds everything
-- else. Safe to re-run — all inserts use ON CONFLICT DO NOTHING.
-- ==================================================================

BEGIN;

-- ==================================================================
-- 1. UPDATE existing public.users profiles with real names/usernames
-- ==================================================================
UPDATE public.users SET username='chef_angel',   fname='Angel', lname='A', middle_init='G'   WHERE user_id='6760a043-18db-4900-8b56-f59b0fa41127';
UPDATE public.users SET username='andrewcooks',  fname='Andrew', lname='Y',  middle_init=NULL   WHERE user_id='6f3ed32e-1608-4aaf-8ead-140bba81ad71';
UPDATE public.users SET username='hasmikarecipes', fname='Hasmika', lname='K',     middle_init=NULL    WHERE user_id='e52d29a0-c08d-4bbf-a861-959f04648417';
UPDATE public.users SET username='neo_eats',   fname='Neo', lname='A',   middle_init=NULL   WHERE user_id='91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec';
UPDATE public.users SET username='trey_eats',   fname='Trey', lname='P',    middle_init=NULL   WHERE user_id='1b62830f-00bf-4f78-aad6-e44d02030106';


-- ==================================================================
-- 2. INGREDIENTS
-- ==================================================================
INSERT INTO public.ingredients (ingredient_id, name, category, calories) VALUES
  ('20000000-0000-0000-0000-000000000001','Garlic',                'Produce',149),
  ('20000000-0000-0000-0000-000000000002','Yellow Onion',          'Produce', 40),
  ('20000000-0000-0000-0000-000000000003','Avocado',               'Produce',160),
  ('20000000-0000-0000-0000-000000000004','Roma Tomato',           'Produce', 18),
  ('20000000-0000-0000-0000-000000000005','Romaine Lettuce',       'Produce', 17),
  ('20000000-0000-0000-0000-000000000006','Lemon',                 'Produce', 29),
  ('20000000-0000-0000-0000-000000000007','Lime',                  'Produce', 30),
  ('20000000-0000-0000-0000-000000000008','Banana',                'Produce', 89),
  ('20000000-0000-0000-0000-000000000009','Red Bell Pepper',       'Produce', 31),
  ('20000000-0000-0000-0000-000000000010','Broccoli',              'Produce', 55),
  ('20000000-0000-0000-0000-000000000011','Baby Spinach',          'Produce', 23),
  ('20000000-0000-0000-0000-000000000012','Cucumber',              'Produce', 16),
  ('20000000-0000-0000-0000-000000000013','Red Onion',             'Produce', 40),
  ('20000000-0000-0000-0000-000000000014','Cherry Tomatoes',       'Produce', 18),
  ('20000000-0000-0000-0000-000000000015','Fresh Ginger',          'Produce', 80),
  ('20000000-0000-0000-0000-000000000016','Jalapeño',              'Produce', 29),
  ('20000000-0000-0000-0000-000000000017','Eggs',                  'Protein',143),
  ('20000000-0000-0000-0000-000000000018','Chicken Breast',        'Protein',165),
  ('20000000-0000-0000-0000-000000000019','Ground Beef',           'Protein',254),
  ('20000000-0000-0000-0000-000000000020','Pancetta',              'Protein',425),
  ('20000000-0000-0000-0000-000000000021','Bacon',                 'Protein',541),
  ('20000000-0000-0000-0000-000000000022','Canned Chickpeas',      'Protein',164),
  ('20000000-0000-0000-0000-000000000023','Unsalted Butter',       'Dairy',  717),
  ('20000000-0000-0000-0000-000000000024','Whole Milk',            'Dairy',   61),
  ('20000000-0000-0000-0000-000000000025','Heavy Cream',           'Dairy',  340),
  ('20000000-0000-0000-0000-000000000026','Parmesan Cheese',       'Dairy',  431),
  ('20000000-0000-0000-0000-000000000027','Cheddar Cheese',        'Dairy',  403),
  ('20000000-0000-0000-0000-000000000028','Feta Cheese',           'Dairy',  264),
  ('20000000-0000-0000-0000-000000000029','Spaghetti Pasta',       'Grains', 371),
  ('20000000-0000-0000-0000-000000000030','All-Purpose Flour',     'Grains', 364),
  ('20000000-0000-0000-0000-000000000031','Sandwich Bread',        'Grains', 265),
  ('20000000-0000-0000-0000-000000000032','Corn Tortillas',        'Grains', 218),
  ('20000000-0000-0000-0000-000000000033','Long Grain White Rice', 'Grains', 365),
  ('20000000-0000-0000-0000-000000000034','Olive Oil',             'Pantry', 884),
  ('20000000-0000-0000-0000-000000000035','Vegetable Oil',         'Pantry', 884),
  ('20000000-0000-0000-0000-000000000036','Salt',                  'Pantry',   0),
  ('20000000-0000-0000-0000-000000000037','Black Pepper',          'Pantry', 251),
  ('20000000-0000-0000-0000-000000000038','Granulated Sugar',      'Pantry', 387),
  ('20000000-0000-0000-0000-000000000039','Brown Sugar',           'Pantry', 380),
  ('20000000-0000-0000-0000-000000000040','Baking Powder',         'Pantry',  53),
  ('20000000-0000-0000-0000-000000000041','Baking Soda',           'Pantry',   0),
  ('20000000-0000-0000-0000-000000000042','Vanilla Extract',       'Pantry', 288),
  ('20000000-0000-0000-0000-000000000043','Soy Sauce',             'Pantry',  53),
  ('20000000-0000-0000-0000-000000000044','Anchovy Paste',         'Pantry', 130),
  ('20000000-0000-0000-0000-000000000045','Canned Diced Tomatoes', 'Pantry',  24),
  ('20000000-0000-0000-0000-000000000046','Coconut Milk',          'Pantry', 197),
  ('20000000-0000-0000-0000-000000000047','Chocolate Chips',       'Pantry', 488),
  ('20000000-0000-0000-0000-000000000048','Ground Cumin',          'Spices', 375),
  ('20000000-0000-0000-0000-000000000049','Smoked Paprika',        'Spices', 282),
  ('20000000-0000-0000-0000-000000000050','Chili Powder',          'Spices', 282),
  ('20000000-0000-0000-0000-000000000051','Dried Oregano',         'Spices', 265),
  ('20000000-0000-0000-0000-000000000052','Ground Turmeric',       'Spices', 312),
  ('20000000-0000-0000-0000-000000000053','Garlic Powder',         'Spices', 331),
  ('20000000-0000-0000-0000-000000000054','Red Pepper Flakes',     'Spices', 282),
  ('20000000-0000-0000-0000-000000000055','Ground Cinnamon',       'Spices', 247)
ON CONFLICT (ingredient_id) DO NOTHING;


-- ==================================================================
-- 3. RECIPES
-- ==================================================================
INSERT INTO public.recipes
  (recipe_id,title,description,meal_type,cuisine,cook_time_minutes,prep_time_minutes,difficulty,servings,instructions)
VALUES
('30000000-0000-0000-0000-000000000001','Spaghetti Carbonara',
 'A classic Roman pasta dish with a rich, creamy egg and parmesan sauce, crispy pancetta, and plenty of black pepper. No cream needed.',
 'Dinner','Italian',20,10,'medium',4,
 '{"instructions":[{"step":1,"instruction":"Bring a large pot of heavily salted water to a boil. Cook spaghetti until al dente according to package directions. Reserve 1 cup of pasta cooking water before draining.","ingredients":[{"name":"Spaghetti Pasta"},{"name":"Salt"}]},{"step":2,"instruction":"While pasta cooks, dice the pancetta into small cubes. Cook in a large skillet over medium heat until crispy and golden, about 5 minutes. Add minced garlic and cook 1 minute more. Remove pan from heat.","ingredients":[{"name":"Pancetta"},{"name":"Garlic"}]},{"step":3,"instruction":"In a bowl, whisk together eggs, finely grated parmesan, and a generous amount of freshly cracked black pepper until smooth and combined.","ingredients":[{"name":"Eggs"},{"name":"Parmesan Cheese"},{"name":"Black Pepper"}]},{"step":4,"instruction":"Add the hot drained pasta to the skillet with pancetta. Pour the egg mixture over the pasta, tossing constantly with tongs. Add reserved pasta water a splash at a time until a creamy, glossy sauce forms. Serve immediately topped with extra parmesan.","ingredients":[{"name":"Parmesan Cheese"}]}]}'),
('30000000-0000-0000-0000-000000000002','Fluffy Buttermilk Pancakes',
 'Light, golden, and impossibly fluffy pancakes perfect for a weekend breakfast. The secret is not overmixing the batter.',
 'Breakfast','American',20,10,'easy',4,
 '{"instructions":[{"step":1,"instruction":"In a large bowl, whisk together the flour, sugar, baking powder, baking soda, and salt until combined.","ingredients":[{"name":"All-Purpose Flour"},{"name":"Granulated Sugar"},{"name":"Baking Powder"},{"name":"Baking Soda"},{"name":"Salt"}]},{"step":2,"instruction":"In a separate bowl, whisk together the eggs, milk, melted butter, and vanilla extract.","ingredients":[{"name":"Eggs"},{"name":"Whole Milk"},{"name":"Unsalted Butter"},{"name":"Vanilla Extract"}]},{"step":3,"instruction":"Pour the wet ingredients into the dry ingredients and stir gently until just combined. Do not overmix — lumps are completely fine and make for fluffier pancakes."},{"step":4,"instruction":"Heat a non-stick griddle or skillet over medium heat and lightly coat with butter. Pour about 1/4 cup of batter per pancake. Cook until bubbles form on the surface and edges look set, about 2 minutes. Flip and cook 1-2 minutes more until golden brown.","ingredients":[{"name":"Unsalted Butter"}]},{"step":5,"instruction":"Serve stacked with additional butter and maple syrup. Keep finished pancakes warm in a 200F oven while you finish the batch."}]}'),
('30000000-0000-0000-0000-000000000003','Classic Caesar Salad',
 'Crisp romaine lettuce tossed in a bold homemade Caesar dressing with golden croutons and shaved parmesan. Restaurant quality at home.',
 'Lunch','American',10,15,'easy',4,
 '{"instructions":[{"step":1,"instruction":"Make the dressing: whisk together anchovy paste, minced garlic, a squeeze of lemon juice, and olive oil until emulsified. Season with black pepper.","ingredients":[{"name":"Anchovy Paste"},{"name":"Garlic"},{"name":"Lemon"},{"name":"Olive Oil"},{"name":"Black Pepper"}]},{"step":2,"instruction":"Tear sandwich bread into rough 1-inch chunks. Toast in a skillet with olive oil over medium heat until golden and crunchy, about 5 minutes. Season with salt.","ingredients":[{"name":"Sandwich Bread"},{"name":"Olive Oil"},{"name":"Salt"}]},{"step":3,"instruction":"Chop the romaine lettuce into bite-sized pieces and place in a large chilled bowl.","ingredients":[{"name":"Romaine Lettuce"}]},{"step":4,"instruction":"Drizzle the dressing over the lettuce and toss well to coat every leaf. Add the croutons and shaved parmesan, toss gently once more, and serve immediately.","ingredients":[{"name":"Parmesan Cheese"}]}]}'),
('30000000-0000-0000-0000-000000000004','Chicken Stir Fry',
 'A quick and colorful weeknight dinner with tender chicken, crisp-tender vegetables, and a savory ginger-soy sauce. On the table in 25 minutes.',
 'Dinner','Asian',15,10,'medium',4,
 '{"instructions":[{"step":1,"instruction":"Slice chicken breast into thin, even strips. In a small bowl, stir together the soy sauce, minced garlic, and freshly grated ginger to make the sauce.","ingredients":[{"name":"Chicken Breast"},{"name":"Soy Sauce"},{"name":"Garlic"},{"name":"Fresh Ginger"}]},{"step":2,"instruction":"Heat vegetable oil in a wok or large skillet over high heat until smoking. Add the chicken in a single layer and cook without stirring for 2 minutes, then stir-fry until golden and cooked through. Transfer to a plate.","ingredients":[{"name":"Vegetable Oil"}]},{"step":3,"instruction":"Add the diced onion to the same pan and stir-fry 2 minutes. Add the broccoli florets and sliced red bell pepper. Stir-fry over high heat for 3-4 minutes until tender-crisp.","ingredients":[{"name":"Yellow Onion"},{"name":"Broccoli"},{"name":"Red Bell Pepper"}]},{"step":4,"instruction":"Return the chicken to the pan, pour the sauce over everything, and toss for 1 minute until coated and glossy. Serve immediately over steamed white rice.","ingredients":[{"name":"Long Grain White Rice"}]}]}'),
('30000000-0000-0000-0000-000000000005','Smashed Avocado Toast',
 'Thick-cut toasted bread loaded with seasoned smashed avocado and a fried egg. Simple, satisfying breakfast or brunch.',
 'Breakfast','American',5,5,'easy',2,
 '{"instructions":[{"step":1,"instruction":"Toast the bread slices until deeply golden and crispy.","ingredients":[{"name":"Sandwich Bread"}]},{"step":2,"instruction":"Halve the avocados, remove the pits, and scoop the flesh into a bowl. Add a squeeze of lemon juice, salt, and black pepper. Mash with a fork to your desired consistency.","ingredients":[{"name":"Avocado"},{"name":"Lemon"},{"name":"Salt"},{"name":"Black Pepper"}]},{"step":3,"instruction":"Spread the mashed avocado generously over each slice of toast. Finish with a pinch of red pepper flakes.","ingredients":[{"name":"Red Pepper Flakes"}]},{"step":4,"instruction":"For extra protein, fry an egg in a little butter over medium heat until whites are set but yolk is still runny. Place on top of the avocado toast and serve immediately.","ingredients":[{"name":"Eggs"},{"name":"Unsalted Butter"}]}]}'),
('30000000-0000-0000-0000-000000000006','Vegetable Coconut Curry',
 'A fragrant, warming vegan curry loaded with chickpeas and spinach in a creamy coconut tomato sauce. Serve over fluffy rice for a complete meal.',
 'Dinner','Indian',25,10,'medium',4,
 '{"instructions":[{"step":1,"instruction":"Heat olive oil in a large pot over medium heat. Add diced onion and cook until softened and lightly golden, about 6 minutes.","ingredients":[{"name":"Olive Oil"},{"name":"Yellow Onion"}]},{"step":2,"instruction":"Add minced garlic and freshly grated ginger and cook for 1 minute. Add ground cumin, turmeric, and chili powder, stirring for 30 seconds until fragrant.","ingredients":[{"name":"Garlic"},{"name":"Fresh Ginger"},{"name":"Ground Cumin"},{"name":"Ground Turmeric"},{"name":"Chili Powder"}]},{"step":3,"instruction":"Pour in the canned diced tomatoes and coconut milk. Stir well to combine and bring to a gentle simmer.","ingredients":[{"name":"Canned Diced Tomatoes"},{"name":"Coconut Milk"}]},{"step":4,"instruction":"Drain and rinse the chickpeas and add them to the pot. Simmer uncovered for 15 minutes until the sauce thickens.","ingredients":[{"name":"Canned Chickpeas"}]},{"step":5,"instruction":"Stir in the baby spinach in two batches until wilted. Season with salt to taste. Serve over steamed white rice.","ingredients":[{"name":"Baby Spinach"},{"name":"Salt"},{"name":"Long Grain White Rice"}]}]}'),
('30000000-0000-0000-0000-000000000007','Greek Salad',
 'A vibrant, no-cook salad of crisp vegetables, briny feta, and a simple olive oil dressing. Ready in 10 minutes.',
 'Lunch','Mediterranean',0,10,'easy',4,
 '{"instructions":[{"step":1,"instruction":"Chop the cucumber, roma tomatoes, and red onion into roughly 1-inch chunks and add to a large serving bowl.","ingredients":[{"name":"Cucumber"},{"name":"Roma Tomato"},{"name":"Red Onion"}]},{"step":2,"instruction":"Halve the cherry tomatoes and add to the bowl. Crumble the feta cheese over the top in large pieces.","ingredients":[{"name":"Cherry Tomatoes"},{"name":"Feta Cheese"}]},{"step":3,"instruction":"Drizzle generously with olive oil and a good squeeze of lemon juice. Sprinkle with dried oregano, salt, and black pepper.","ingredients":[{"name":"Olive Oil"},{"name":"Lemon"},{"name":"Dried Oregano"},{"name":"Salt"},{"name":"Black Pepper"}]},{"step":4,"instruction":"Toss lightly to combine. Serve immediately or refrigerate for up to 20 minutes to let the flavors develop."}]}'),
('30000000-0000-0000-0000-000000000008','Chocolate Chip Cookies',
 'Perfectly chewy in the center, crisp at the edges, and loaded with chocolate chips. The ultimate classic cookie recipe.',
 'Dessert','American',11,15,'easy',24,
 '{"instructions":[{"step":1,"instruction":"Preheat oven to 375 F. Beat together softened butter, granulated sugar, and brown sugar until light and fluffy, about 3 minutes.","ingredients":[{"name":"Unsalted Butter"},{"name":"Granulated Sugar"},{"name":"Brown Sugar"}]},{"step":2,"instruction":"Beat in the eggs one at a time until fully incorporated, then mix in the vanilla extract.","ingredients":[{"name":"Eggs"},{"name":"Vanilla Extract"}]},{"step":3,"instruction":"In a separate bowl, whisk together the flour, baking soda, and salt. Gradually add to the butter mixture, stirring until just combined.","ingredients":[{"name":"All-Purpose Flour"},{"name":"Baking Soda"},{"name":"Salt"}]},{"step":4,"instruction":"Fold in the chocolate chips until evenly distributed throughout the dough.","ingredients":[{"name":"Chocolate Chips"}]},{"step":5,"instruction":"Drop rounded tablespoons of dough onto ungreased baking sheets, spacing 2 inches apart. Bake 9-11 minutes until edges are golden but centers look slightly underdone. Cool on baking sheet 2 minutes before transferring."}]}'),
('30000000-0000-0000-0000-000000000009','Classic French Omelette',
 'A silky, perfectly folded French-style omelette with a custardy interior. A fundamental technique every home cook should master.',
 'Breakfast','French',5,5,'easy',1,
 '{"instructions":[{"step":1,"instruction":"Crack the eggs into a bowl and whisk vigorously with a fork until no streaks of white remain and the mixture is pale and foamy. Season with salt and black pepper.","ingredients":[{"name":"Eggs"},{"name":"Salt"},{"name":"Black Pepper"}]},{"step":2,"instruction":"Melt the butter in an 8-inch non-stick skillet over medium-high heat, swirling to coat the pan. When the foam begins to subside, pour in the eggs.","ingredients":[{"name":"Unsalted Butter"}]},{"step":3,"instruction":"Immediately begin stirring with a rubber spatula in rapid small circular motions while shaking the pan back and forth. Keep the eggs moving constantly."},{"step":4,"instruction":"When the eggs are just barely set but the surface is still slightly glossy and creamy, stop stirring. Scatter the shredded cheddar over one half of the omelette.","ingredients":[{"name":"Cheddar Cheese"}]},{"step":5,"instruction":"Tilt the pan at 45 degrees over the plate and use the spatula to fold the omelette in half as it slides out. The finished omelette should be pale yellow with no browning. Serve immediately."}]}'),
('30000000-0000-0000-0000-000000000010','Crispy Beef Tacos',
 'Boldly seasoned ground beef in warm charred corn tortillas topped with fresh tomato, melted cheddar, and a squeeze of lime.',
 'Dinner','Mexican',15,10,'easy',4,
 '{"instructions":[{"step":1,"instruction":"Heat vegetable oil in a large skillet over medium-high heat. Add the ground beef and cook, breaking it into small crumbles, until browned and cooked through, about 6-8 minutes.","ingredients":[{"name":"Vegetable Oil"},{"name":"Ground Beef"}]},{"step":2,"instruction":"Add the diced onion and minced garlic to the beef and cook for 2 minutes until softened. Drain any excess fat from the pan.","ingredients":[{"name":"Yellow Onion"},{"name":"Garlic"}]},{"step":3,"instruction":"Season the meat with chili powder, ground cumin, smoked paprika, salt, and black pepper. Stir well and cook for 1 more minute until the spices are fragrant.","ingredients":[{"name":"Chili Powder"},{"name":"Ground Cumin"},{"name":"Smoked Paprika"},{"name":"Salt"},{"name":"Black Pepper"}]},{"step":4,"instruction":"Warm the corn tortillas directly over a gas flame or in a dry hot skillet until lightly charred in spots and pliable.","ingredients":[{"name":"Corn Tortillas"}]},{"step":5,"instruction":"Fill each tortilla with the seasoned beef. Top with finely diced roma tomato, shredded cheddar cheese, and a squeeze of fresh lime juice. Serve immediately.","ingredients":[{"name":"Roma Tomato"},{"name":"Cheddar Cheese"},{"name":"Lime"}]}]}'),
('30000000-0000-0000-0000-000000000011','Banana Smoothie Bowl',
 'A thick, creamy frozen banana base blended to soft-serve consistency. Naturally sweet and endlessly customizable with your favorite toppings.',
 'Breakfast','American',0,10,'easy',2,
 '{"instructions":[{"step":1,"instruction":"Peel 3 bananas, slice them into coins, and freeze for at least 2 hours or overnight until completely solid.","ingredients":[{"name":"Banana"}]},{"step":2,"instruction":"Transfer the frozen banana slices to a blender. Add a small splash of milk and blend until completely smooth and resembling soft-serve ice cream. Add milk a tablespoon at a time only if absolutely necessary — the goal is thick, not pourable.","ingredients":[{"name":"Whole Milk"}]},{"step":3,"instruction":"Pour into a bowl. Top with fresh banana slices and any desired toppings such as granola, honey, nut butter, or fresh berries. Eat immediately before it melts.","ingredients":[{"name":"Banana"}]}]}'),
('30000000-0000-0000-0000-000000000012','Garlic Butter Fried Rice',
 'Day-old rice tossed in brown butter with loads of garlic, scrambled eggs, and a hit of soy sauce. The best use of leftover rice you will ever make.',
 'Dinner','Asian',10,5,'easy',2,
 '{"instructions":[{"step":1,"instruction":"This recipe works best with day-old rice that has dried out slightly in the fridge. Break up any clumps with your hands before cooking.","ingredients":[{"name":"Long Grain White Rice"}]},{"step":2,"instruction":"Melt butter in a large skillet or wok over high heat. Cook, swirling the pan, until the butter turns golden brown and smells nutty. Add the minced garlic and cook for 30 seconds, stirring constantly.","ingredients":[{"name":"Unsalted Butter"},{"name":"Garlic"}]},{"step":3,"instruction":"Add the rice to the pan and spread into an even layer. Press it down and let it fry undisturbed for 2 minutes to develop a lightly crispy crust on the bottom. Stir, pressing again, and fry for another 2 minutes."},{"step":4,"instruction":"Push the rice to one side of the pan. Crack the eggs into the empty space and scramble them with a spatula until just set. Immediately fold the scrambled eggs into the rice.","ingredients":[{"name":"Eggs"}]},{"step":5,"instruction":"Drizzle soy sauce over the rice and toss everything well to combine. Season with salt and black pepper to taste. Serve hot.","ingredients":[{"name":"Soy Sauce"},{"name":"Salt"},{"name":"Black Pepper"}]}]}')
ON CONFLICT (recipe_id) DO NOTHING;


-- ==================================================================
-- 4. RECIPE INGREDIENTS
-- ==================================================================
INSERT INTO public.recipe_ingredient (recipe_id,ingredient_id,quantity,unit) VALUES
  ('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000029',400,'g'),
  ('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000017',4,'large'),
  ('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000026',100,'g grated'),
  ('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000020',200,'g'),
  ('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000037',1,'tsp'),
  ('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001',2,'cloves'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000030',2,'cups'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000038',2,'tbsp'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000040',2,'tsp'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000041',0.5,'tsp'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000036',0.5,'tsp'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000017',2,'large'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000024',1.5,'cups'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000023',4,'tbsp melted'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000042',1,'tsp'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000005',2,'heads'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000026',60,'g shaved'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000031',3,'slices'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000006',1,'whole'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000001',2,'cloves'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000044',1,'tsp'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000034',3,'tbsp'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000037',0.5,'tsp'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000018',500,'g'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000010',2,'cups florets'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000009',1,'whole sliced'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000043',3,'tbsp'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000001',3,'cloves'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000015',1,'tsp grated'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000035',2,'tbsp'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000002',1,'whole diced'),
  ('30000000-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000033',1,'cup dry'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000031',2,'slices'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000003',2,'whole'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000006',0.5,'whole'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000036',0.25,'tsp'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000037',0.25,'tsp'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000054',0.25,'tsp'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000017',2,'large'),
  ('30000000-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000023',1,'tbsp'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000034',2,'tbsp'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000002',1,'whole diced'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000001',4,'cloves'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000015',1,'tbsp grated'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000048',1,'tsp'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000052',1,'tsp'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000050',1,'tsp'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000045',400,'g can'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000046',400,'ml can'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000022',400,'g can drained'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000011',3,'cups'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000036',1,'tsp'),
  ('30000000-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000033',2,'cups dry'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000012',1,'whole'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000004',3,'whole'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000013',0.5,'whole'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000014',1,'cup'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000028',200,'g'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000034',3,'tbsp'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000006',1,'whole'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000051',1,'tsp'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000036',0.5,'tsp'),
  ('30000000-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000037',0.25,'tsp'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000023',230,'g softened'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000038',0.75,'cup'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000039',0.75,'cup packed'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000017',2,'large'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000042',2,'tsp'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000030',2.25,'cups'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000041',1,'tsp'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000036',1,'tsp'),
  ('30000000-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000047',2,'cups'),
  ('30000000-0000-0000-0000-000000000009','20000000-0000-0000-0000-000000000017',3,'large'),
  ('30000000-0000-0000-0000-000000000009','20000000-0000-0000-0000-000000000036',0.25,'tsp'),
  ('30000000-0000-0000-0000-000000000009','20000000-0000-0000-0000-000000000037',0.25,'tsp'),
  ('30000000-0000-0000-0000-000000000009','20000000-0000-0000-0000-000000000023',1,'tbsp'),
  ('30000000-0000-0000-0000-000000000009','20000000-0000-0000-0000-000000000027',30,'g shredded'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000035',1,'tbsp'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000019',500,'g'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000002',1,'whole diced'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000001',3,'cloves'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000050',2,'tsp'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000048',1,'tsp'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000049',1,'tsp'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000036',0.5,'tsp'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000037',0.25,'tsp'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000032',8,'whole'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000004',2,'whole diced'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000027',100,'g shredded'),
  ('30000000-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000007',2,'whole'),
  ('30000000-0000-0000-0000-000000000011','20000000-0000-0000-0000-000000000008',3,'whole'),
  ('30000000-0000-0000-0000-000000000011','20000000-0000-0000-0000-000000000024',0.5,'cup'),
  ('30000000-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000033',2,'cups cooked'),
  ('30000000-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000023',2,'tbsp'),
  ('30000000-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000001',4,'cloves'),
  ('30000000-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000017',2,'large'),
  ('30000000-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000043',2,'tbsp'),
  ('30000000-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000036',0.5,'tsp'),
  ('30000000-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000037',0.25,'tsp')
ON CONFLICT (recipe_id,ingredient_id) DO NOTHING;


-- ==================================================================
-- 5. RECIPE RATINGS
--    aa=6760a043  ay=6f3ed32e  hk=e52d29a0  na=91f0fb9f  tp=1b62830f
-- ==================================================================
INSERT INTO public.recipe_rating (user_id,recipe_id,rating) VALUES
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000001',5),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000001',4),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000001',5),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000001',3),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000002',5),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000002',5),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000002',4),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','30000000-0000-0000-0000-000000000002',5),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000003',4),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000003',3),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000003',5),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000004',4),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000004',4),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000004',5),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000005',5),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000005',4),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000005',5),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000006',4),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000006',3),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000006',5),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000007',4),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000007',5),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000008',5),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000008',5),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000008',5),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000008',4),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','30000000-0000-0000-0000-000000000008',5),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000009',4),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000009',5),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','30000000-0000-0000-0000-000000000009',4),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000010',5),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000010',5),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000010',4),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000011',5),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000011',4),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000012',4),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000012',5),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000012',4)
ON CONFLICT (user_id,recipe_id) DO NOTHING;


-- ==================================================================
-- 6. PANTRY
-- ==================================================================
INSERT INTO public.pantry (user_id,ingredient_id) VALUES
  -- aa@gmail.com — well-stocked kitchen (great match: Carbonara, Cookies, Omelette)
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000001'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000002'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000003'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000006'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000017'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000020'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000023'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000024'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000026'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000029'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000030'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000031'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000034'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000036'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000037'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000038'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000039'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000040'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000041'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000042'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000047'),
  ('6760a043-18db-4900-8b56-f59b0fa41127','20000000-0000-0000-0000-000000000054'),
  -- ay@gmail.com — Mexican / fresh focus (great match: Beef Tacos, Smoothie Bowl)
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000001'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000002'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000003'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000004'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000007'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000008'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000013'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000016'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000019'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000024'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000027'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000032'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000035'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000036'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000037'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000048'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000049'),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','20000000-0000-0000-0000-000000000050'),
  -- hk@gmail.com — Asian cooking focus (great match: Stir Fry, Fried Rice)
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000001'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000002'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000009'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000010'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000015'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000017'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000018'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000023'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000033'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000035'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000036'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000037'),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','20000000-0000-0000-0000-000000000043'),
  -- na@gmail.com — healthy / vegetarian (great match: Curry, Greek Salad, Avocado Toast)
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000001'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000002'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000003'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000006'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000011'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000012'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000013'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000014'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000015'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000022'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000028'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000034'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000036'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000045'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000046'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000048'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000050'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000051'),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','20000000-0000-0000-0000-000000000052'),
  -- tp@gmail.com — baking focus (great match: Pancakes, Cookies, Omelette)
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000001'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000017'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000023'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000024'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000027'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000030'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000036'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000037'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000038'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000039'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000040'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000041'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000042'),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','20000000-0000-0000-0000-000000000047')
ON CONFLICT (user_id,ingredient_id) DO NOTHING;


-- ==================================================================
-- 7. RECIPE_USER (saved favorites)
-- ==================================================================
INSERT INTO public.recipe_user (user_id,recipe_id,created_or_saved) VALUES
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000001','S'::created_or_saved),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000004','S'::created_or_saved),
  ('6760a043-18db-4900-8b56-f59b0fa41127','30000000-0000-0000-0000-000000000008','S'::created_or_saved),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000010','S'::created_or_saved),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000006','S'::created_or_saved),
  ('6f3ed32e-1608-4aaf-8ead-140bba81ad71','30000000-0000-0000-0000-000000000011','S'::created_or_saved),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000004','S'::created_or_saved),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000012','S'::created_or_saved),
  ('e52d29a0-c08d-4bbf-a861-959f04648417','30000000-0000-0000-0000-000000000009','S'::created_or_saved),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000006','S'::created_or_saved),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000007','S'::created_or_saved),
  ('91f0fb9f-8f9f-4cc9-bb92-bde44b0e6cec','30000000-0000-0000-0000-000000000005','S'::created_or_saved),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','30000000-0000-0000-0000-000000000008','S'::created_or_saved),
  ('1b62830f-00bf-4f78-aad6-e44d02030106','30000000-0000-0000-0000-000000000002','S'::created_or_saved)
ON CONFLICT (user_id,recipe_id) DO NOTHING;


COMMIT;


-- ==================================================================
-- VERIFICATION (uncomment and run each line individually)
-- ==================================================================
-- SELECT COUNT(*) AS ingredients   FROM public.ingredients;       -- 55
-- SELECT COUNT(*) AS recipes       FROM public.recipes;           -- 12
-- SELECT COUNT(*) AS rec_ing       FROM public.recipe_ingredient; -- 86
-- SELECT COUNT(*) AS ratings       FROM public.recipe_rating;     -- 38
-- SELECT COUNT(*) AS pantry_rows   FROM public.pantry;            -- 72
-- SELECT COUNT(*) AS saved         FROM public.recipe_user;       -- 14

-- Spot-check aa@gmail.com — should see 22 pantry items, 3 saved recipes, 100% match on Carbonara:
-- SELECT COUNT(*) FROM public.pantry      WHERE user_id = '6760a043-18db-4900-8b56-f59b0fa41127';
-- SELECT COUNT(*) FROM public.recipe_user WHERE user_id = '6760a043-18db-4900-8b56-f59b0fa41127';
-- SELECT username, fname, lname FROM public.users WHERE user_id = '6760a043-18db-4900-8b56-f59b0fa41127';
