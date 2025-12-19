# Verb Drill

Interactive flashcards for verb conjugation practice.

## Structure

```
verb-drill/
├── index.html              # Landing (if needed)
├── {lang}-{variant}/       # pt-eu, pt-br, es-es
│   ├── index.html          # Verb list with language badges
│   └── {verb}/
│       ├── en.html         # English origin
│       └── ru.html         # Russian origin
└── README.md
```

## Supported languages

Target languages:
- `pt-eu` — Portuguese (European)

Origin languages (for translations):
- `en` — English 🇬🇧
- `ru` — Russian 🇷🇺

## Page requirements

Each verb page must have:
- 100 phrases sorted by frequency (most common first)
- All tenses: Presente, Pretérito Imperfeito, Pretérito Perfeito, Futuro, Condicional, Presente do Conjuntivo, Imperfeito do Conjuntivo
- Questions, negations, polite requests, common expressions
- Verb forms highlighted in target language
- Tense tags for each phrase
- Search functionality
- Show/hide all buttons
- Dark theme, mobile-friendly
- Back link to verb list

## When adding new verb

1. Create `{lang}/{verb}/en.html` and `{lang}/{verb}/ru.html`
2. Update `{lang}/index.html` to add verb card with language badges
3. Follow existing file structure exactly (copy from poder as template)
