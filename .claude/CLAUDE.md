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

## iOS App

SwiftUI app in `VerbDrill/`. Bundle ID: `cc.verb-drill.app`

### Structure
```
VerbDrill/
├── project.yml              # XcodeGen config (regenerates .xcodeproj)
├── export_json.rb           # YAML→JSON converter
├── privacy-policy.md        # Source for privacy page
├── screenshots/             # App Store screenshots
└── VerbDrill/
    ├── App.swift            # Entry point
    ├── ContentView.swift    # Root view
    ├── Models/
    │   ├── DataModels.swift # Verb, Phrase, Language structs
    │   └── DataManager.swift # Loads JSON, caches verbs
    ├── Views/
    │   ├── VerbListView.swift   # Verb list screen
    │   ├── DrillView.swift      # Flashcard drill
    │   └── SettingsView.swift   # Language picker
    ├── Resources/           # JSON data (generated)
    └── Assets.xcassets/     # Icon, colors
```

### Build
```bash
cd VerbDrill
ruby export_json.rb    # Re-export JSON after YAML changes
xcodegen generate      # Regenerate .xcodeproj
open VerbDrill.xcodeproj
```

### Data Flow
1. `export_json.rb` reads `src/data/` YAML
2. Outputs `data.json` (index) + `{lang}_{verb}.json` per verb
3. App bundles JSON in Resources/
4. `DataManager` loads on launch, caches verb files

### Version Bump
Edit `project.yml`:
- `MARKETING_VERSION`: user-facing (1.0.0)
- `CURRENT_PROJECT_VERSION`: build number (1, 2, 3...)

Then: `xcodegen generate` → Archive

### App Store
- Privacy URL: `https://verb-drill.cc/privacy.html`
- Category: Education
- Rating: 4+
- Price: Free

## Commits

One line. Focus on why. No AI mentions.
