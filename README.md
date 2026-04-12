# Recipeople 🍽️

A recipe recommendation web app that suggests recipes based on the ingredients you already have at home. Built with Vue 3, Vite, and Supabase.

---

## Features

- **Recipe Feed** — Personalized recipe recommendations ranked by how many pantry ingredients you already own, grouped into match tiers (Perfect, Good, Partial, Missing)
- **Recipe Search** — Search recipes by name or description with filters for meal type, cuisine, difficulty, and cook time; sorted by community rating
- **Pantry Manager** — Track your available ingredients with a searchable add/remove interface grouped by category
- **Recipe Instructions** — Step-by-step cooking guide with interactive checkboxes to mark progress and an inline ingredient highlight showing what you have on hand
- **Favorites** — Save and revisit your favorite recipes in one place
- **Settings** — Edit your profile, upload an avatar, change your password, and manage your account

---

## Tech Stack

| Layer       | Technology                                      |
|-------------|-------------------------------------------------|
| Frontend    | [Vue 3](https://vuejs.org/) + [Vite](https://vitejs.dev/) |
| Routing     | [Vue Router 4](https://router.vuejs.org/)       |
| State       | [Pinia](https://pinia.vuejs.org/)               |
| Styling     | [Tailwind CSS v3](https://tailwindcss.com/)     |
| Backend     | [Supabase](https://supabase.com/) (PostgreSQL, Auth, Storage) |
| Hosting     | AWS S3 + CloudFront (static)                    |

---

## Project Structure

```
src/
├── lib/
│   └── supabase.js              # Supabase client initialization
├── router/
│   └── index.js                 # Routes with auth guards
├── stores/
│   ├── auth.js                  # Authentication, profile, avatar
│   ├── recipes.js               # Feed, search, single recipe, ratings
│   ├── pantry.js                # Pantry CRUD + ingredient search
│   └── favorites.js             # Save/unsave recipes
├── components/
│   ├── layout/
│   │   ├── AppHeader.vue        # Top bar with logo and avatar
│   │   └── BottomNav.vue        # Mobile bottom navigation
│   ├── recipe/
│   │   ├── RecipeCard.vue       # Recipe card with match bar and rating
│   │   └── StarRating.vue       # Interactive and display star rating
│   ├── pantry/
│   │   └── IngredientSearch.vue # Debounced ingredient search dropdown
│   └── ui/
│       ├── AppModal.vue         # Reusable slide-up modal
│       └── LoadingSpinner.vue   # Animated loading indicator
└── views/
    ├── LoginView.vue
    ├── SignupView.vue
    ├── RecipeFeedView.vue
    ├── RecipeSearchView.vue
    ├── PantryManagerView.vue
    ├── RecipeInstructionsView.vue
    ├── FavoritesView.vue
    └── SettingsView.vue
```

---

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) v18 or higher
- A [Supabase](https://supabase.com/) project with the schema below applied

### 1. Clone the repository

```bash
git clone https://github.com/your-org/recipeople.git
cd recipeople
```

### 2. Install dependencies

```bash
npm install
```

### 3. Configure environment variables

Copy the example env file and fill in your Supabase credentials:

```bash
cp .env.example .env
```

Open `.env` and set:

```env
VITE_SUPABASE_URL=https://your-project-ref.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

You can find both values in your Supabase project under **Settings → API**.

### 4. Set up Supabase Storage

In your Supabase dashboard, go to **Storage** and create a new public bucket named `avatars`. This is used to store user profile pictures.

### 5. Run the development server

```bash
npm run dev
```

The app will be available at `http://localhost:5173`.

---

## Database Schema

The app expects the following tables in your Supabase project:

| Table              | Purpose                                          |
|--------------------|--------------------------------------------------|
| `users`            | User profiles (linked to Supabase Auth)          |
| `ingredients`      | Global ingredient catalog                        |
| `pantry`           | Junction table of user ↔ ingredient              |
| `recipes`          | Recipe data including JSONB step instructions    |
| `recipe_ingredient`| Junction table of recipe ↔ ingredient with qty   |
| `recipe_rating`    | Per-user recipe ratings (1–5)                    |
| `recipe_user`      | Saved/created recipes per user                   |

> The `instructions` column on `recipes` is a validated JSONB field with the following shape:
> ```json
> {
>   "instructions": [
>     {
>       "step": 1,
>       "instruction": "Preheat oven to 375°F.",
>       "ingredients": [{ "name": "butter" }]
>     }
>   ]
> }
> ```

---

## Available Scripts

| Command           | Description                                  |
|-------------------|----------------------------------------------|
| `npm run dev`     | Start local development server               |
| `npm run build`   | Build optimized production bundle to `dist/` |
| `npm run preview` | Preview the production build locally         |

---

## Deployment (AWS S3 + CloudFront)

This app is a static SPA with no server-side rendering required.

1. Build the app:
   ```bash
   npm run build
   ```

2. Upload the contents of the `dist/` folder to your S3 bucket.

3. Configure the S3 bucket for static website hosting and set the error document to `index.html` so Vue Router can handle client-side navigation.

4. Attach a CloudFront distribution pointing at the S3 bucket for HTTPS and global CDN delivery.

5. Add a CloudFront error page rule that redirects `403`/`404` responses to `/index.html` with a `200` status.

---

## Environment Variables Reference

| Variable                   | Required | Description                            |
|----------------------------|----------|----------------------------------------|
| `VITE_SUPABASE_URL`        | Yes      | Your Supabase project URL              |
| `VITE_SUPABASE_ANON_KEY`   | Yes      | Your Supabase anon/public API key      |
| `VITE_AWS_S3_BUCKET`       | No       | S3 bucket name (for deployment docs)   |
| `VITE_AWS_CLOUDFRONT_URL`  | No       | CloudFront distribution URL            |

> Never commit your `.env` file. It is listed in `.gitignore` by default.

---

## Contributing

1. Fork the repository and create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Make your changes and commit them with a descriptive message.
3. Open a pull request against `main` with a summary of what you changed and why.

---

## License

This project is for educational purposes. See your team's agreement for usage terms.
