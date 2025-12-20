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
│       └── pt-eu/
│           ├── index.yml       # Verb list metadata
│           └── {verb}.yml      # Verb data (phrases, forms)
├── assets/
│   ├── css/
│   │   ├── index.css           # Index page styles
│   │   └── verb.css            # Verb page styles
│   └── js/
│       └── verb.js             # Shared verb page logic
├── pt-eu/                      # Generated HTML (don't edit directly)
│   ├── index.html
│   └── {verb}/
│       ├── en.html
│       └── ru.html
├── build.rb                    # Build script
└── README.md
```

## Build

```bash
ruby build.rb
```

Generates HTML from `src/templates/` + `src/data/` → outputs to `pt-eu/`, `en/`

## Adding new verb

1. Create `src/data/pt-eu/{verb}.yml`:
   ```yaml
   slug: verb-name
   name: "🇵🇹 Verb NAME"
   meaning: to do something
   verb_forms: [form1, form2, ...]
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
2. Add verb to `src/data/pt-eu/index.yml`
3. Run `ruby build.rb`

## Supported languages

Target: `en` 🇬🇧, `pt-eu` 🇵🇹
Origin: `en` 🇬🇧, `ru` 🇷🇺

## Commits

Focus on why, not what. Keep concise. No AI mentions.
