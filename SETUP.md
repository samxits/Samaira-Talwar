# Portfolio Setup Guide

Everything you need to get your portfolio online — for free — in about 30 minutes.

---

## Overview

Your portfolio has two parts:
1. **The website** — hosted on Netlify (free)
2. **The database + admin panel** — powered by Supabase (free tier)

You'll need accounts on both. Both have generous free tiers that are more than enough for a personal portfolio.

---

## Step 1: Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and sign up for a free account
2. Click **New project**
3. Fill in:
   - **Organization**: create one with your name (e.g. "Samaira Talwar")
   - **Project name**: `samaira-portfolio`
   - **Database password**: choose something strong and save it somewhere safe
   - **Region**: choose the one closest to Canada (US East or Canada if available)
4. Click **Create new project** — it takes ~2 minutes to spin up

---

## Step 2: Run the database setup

1. In your Supabase dashboard, go to **SQL Editor** (left sidebar, looks like `</>`)
2. Click **New query**
3. Open the file `supabase-setup.sql` from your portfolio folder
4. Copy the entire contents and paste it into the SQL editor
5. Click **Run** (or press Cmd+Enter)

This creates all your tables, sets up security rules, and seeds all your content (articles, experience, skills, languages, certifications, etc.)

---

## Step 3: Get your Supabase credentials

1. In the left sidebar, go to **Project Settings** → **API**
2. You need two values:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon public key** — a long string starting with `eyJ...`
3. Copy both and keep them handy

---

## Step 4: Add credentials to the website files

You need to paste your credentials in **two places**:

### File 1: `js/config.js`

Open this file and replace the placeholders:

```js
const SUPABASE_URL  = 'https://YOUR-PROJECT.supabase.co';   // ← paste your Project URL
const SUPABASE_KEY  = 'eyJ...your-anon-key...';              // ← paste your anon key
```

### File 2: `admin/index.html`

Open this file and search for `YOUR_SUPABASE_URL` (around line 10). Replace both placeholders:

```js
const SUPABASE_URL = 'https://YOUR-PROJECT.supabase.co';    // ← same URL
const SUPABASE_KEY = 'eyJ...your-anon-key...';               // ← same anon key
```

---

## Step 5: Create your admin login

1. In Supabase, go to **Authentication** → **Users** (left sidebar)
2. Click **Invite user** (or **Add user** → **Create new user**)
3. Enter your email: `samairatlwr@gmail.com`
4. Set a strong password — this is what you'll use to log into your admin panel
5. Click **Create user**

---

## Step 6: Push to GitHub

1. If you don't have Git installed: download it from [git-scm.com](https://git-scm.com)
2. If you don't have a GitHub account: sign up at [github.com](https://github.com)
3. Create a **new repository** on GitHub:
   - Go to github.com → click **+** → **New repository**
   - Name it: `portfolio` (or anything you like)
   - Set it to **Public**
   - **Don't** initialize with README
   - Click **Create repository**
4. In Terminal, navigate to your portfolio folder and run:

```bash
cd ~/Downloads/samaira-portfolio
git init
git add .
git commit -m "Initial portfolio"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/portfolio.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username.

---

## Step 7: Deploy on Netlify

1. Go to [netlify.com](https://netlify.com) and sign up (you can log in with GitHub)
2. Click **Add new site** → **Import an existing project**
3. Choose **GitHub** and authorize Netlify to access your repos
4. Select your `portfolio` repository
5. Leave the build settings as-is (the `netlify.toml` handles everything)
6. Click **Deploy site**

Netlify will give you a URL like `amazing-name-123.netlify.app` — that's your live site!

### (Optional) Custom domain

If you own a domain (e.g. `samaira.me`), go to **Site settings** → **Domain management** → **Add custom domain** and follow the instructions.

---

## Step 8: Test everything

1. Open your live Netlify URL
2. Check that the homepage, about, writing, experience, and contact pages all load
3. Go to `your-site.netlify.app/admin` to open the admin panel
4. Log in with the email and password you created in Step 5
5. Try editing something — click on any section, make a change, click Save

---

## Using the admin panel

The admin panel lives at `/admin` on your site. Only you can log in.

| Section | What you can edit |
|---|---|
| **Profile & Bio** | Your tagline, hero bio, about page bio paragraphs, education, location, currently, contact email, LinkedIn/Phoenix URLs |
| **Articles** | Add, edit, delete articles — title, category, date, link, featured status |
| **Experience** | Add, edit, delete work and volunteer roles — org, role, dates, description, tags |
| **Certifications** | Add, edit, delete certifications and courses |
| **Languages** | Adjust language names and fluency levels (0–100 slider) |
| **Skills** | Add and remove skill chips |
| **Stats** | Edit the 4 numbers on the homepage stats band |

Changes you make in the admin panel update instantly — no code, no deployment needed.

---

## Updating the site after making code changes

If you ever edit the HTML/CSS/JS files directly:

```bash
git add .
git commit -m "describe what you changed"
git push
```

Netlify automatically redeploys whenever you push to GitHub. It takes about 30 seconds.

---

## Troubleshooting

**Site loads but content is missing / shows "Loading…" forever**
→ Check that your Supabase credentials are correct in `js/config.js`. Open the browser console (F12) and look for error messages.

**Admin panel login fails**
→ Make sure you created the user in Supabase Authentication (Step 5). Also check the credentials in `admin/index.html`.

**Changes in admin don't appear on the site**
→ Hard-refresh the page (Cmd+Shift+R on Mac). The browser may be caching old content.

**"Invalid API key" error in console**
→ You may have accidentally included extra spaces when pasting the key. Double-check `js/config.js` and `admin/index.html`.

---

## Free tier limits (you won't hit these)

| Service | Limit |
|---|---|
| Netlify | 100GB bandwidth/month, 300 build minutes/month |
| Supabase | 500MB database, 50,000 monthly active users, 2GB file storage |

Your portfolio will use a tiny fraction of any of these.
