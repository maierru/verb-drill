# Verb Drill

Interactive flashcards for verb conjugation practice.

## Structure

```
verb-drill/
├── src/
│   ├── templates/
│   │   ├── verb.html.erb       # Verb page template
│   │   └── index.html.erb      # Index page template
│   └── data/
│       ├── pt-eu/              # Portuguese target
│       │   ├── index.yml
│       │   └── {verb}.yml
│       └── en/                 # English target
│           ├── index.yml
│           └── {verb}.yml
├── assets/
│   ├── css/
│   │   ├── index.css
│   │   └── verb.css
│   └── js/
│       └── verb.js
├── pt-eu/                      # Generated (don't edit)
├── en/                         # Generated (don't edit)
└── build.rb
```

## Build

```bash
ruby build.rb
```

Generates HTML from `src/templates/` + `src/data/` → `pt-eu/`, `en/`

## Adding verb to pt-eu (learning Portuguese)

1. Create `src/data/pt-eu/{verb}.yml`:
   ```yaml
   slug: verb-name
   name: "🇵🇹 Verb NAME"
   meaning: to do something
   verb_forms: [form1, form2]
   phrases:
     en:
       - en: "English phrase"
         pt: "Portuguese phrase"
         tense: "Presente"
     ru:
       - ru: "Russian phrase"
         pt: "Portuguese phrase"
         tense: "Presente"
   ```
2. Add to `src/data/pt-eu/index.yml`
3. Run `ruby build.rb`

## Adding verb to en (learning English)

1. Create `src/data/en/{verb}.yml`:
   ```yaml
   slug: verb-name
   name: "🇬🇧 Verb NAME"
   meaning: to do something
   verb_forms: [form1, form2]
   phrases:
     ru:
       - ru: "Russian phrase"
         en: "English phrase"
         tense: "Present"
     pt:
       - pt: "Portuguese phrase"
         en: "English phrase"
         tense: "Present"
   ```
2. Add to `src/data/en/index.yml`
3. Run `ruby build.rb`

## Languages

Target (what user learns): `pt-eu` 🇵🇹, `en` 🇬🇧
Origin (user's native): `en` 🇬🇧, `ru` 🇷🇺, `pt` 🇵🇹

## Commits

One line. Focus on why. No AI mentions.
