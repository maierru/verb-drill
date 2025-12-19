# Verb Drill

**Live:** [verb-drill.cc](https://verb-drill.cc/)

Practice verb conjugations through real-world phrases. Read in your native language, translate to target language, then reveal the answer.

## Structure

```
verb-drill/
├── index.html              # Main landing page
├── {lang}-{variant}/       # e.g., pt-eu (Portuguese European)
│   ├── index.html          # List of verbs for this language
│   └── {verb}/
│       └── {origin}.html   # e.g., ru.html (from Russian)
└── README.md
```

## Available

- [🇵🇹 Portuguese (European)](https://verb-drill.cc/pt-eu/)

## How it works

1. You see a phrase in your native language
2. Try to translate it mentally
3. Click to reveal the correct translation
4. Verb forms are highlighted for easy recognition

## Features

- Click-to-reveal translations
- Search/filter phrases
- Show/hide all at once
- Tense tags for each phrase
- Mobile-friendly design
- Works offline (static HTML)

## Creating new verb pages

Use this prompt with an AI assistant to generate new verb practice pages:

```
I'm learning [TARGET_LANGUAGE] and want to master the verb [VERB]. Create an interactive HTML page with 100 popular phrases sorted by frequency (most common first).

Requirements:
- [ORIGIN_LANGUAGE] phrase first, [TARGET_LANGUAGE] translation hidden (click to reveal)
- Cover all tenses: Presente, Pretérito Imperfeito, Pretérito Perfeito, Futuro, Condicional, Presente do Conjuntivo, Imperfeito do Conjuntivo
- Include questions, negations, polite requests, and common expressions
- Highlight all verb forms in the [TARGET_LANGUAGE] text
- Add tense tags for each phrase
- Include search functionality
- "Show all" / "Hide all" buttons
- Dark theme, mobile-friendly design

The verb to practice: [VERB]
```

Replace:
- `[TARGET_LANGUAGE]` — language you're learning (e.g., European Portuguese, Brazilian Portuguese, Spanish)
- `[ORIGIN_LANGUAGE]` — your native language (e.g., Russian, English)
- `[VERB]` — verb to practice (e.g., `ser`, `estar`, `ter`, `fazer`)
