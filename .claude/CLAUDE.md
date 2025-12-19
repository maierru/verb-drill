# Verb Drill

Interactive flashcards for verb conjugation practice.

## Structure

```
verb-drill/
├── README.md               # Landing page with links
├── {lang}-{variant}/       # pt-eu, pt-br, es-es
│   ├── index.html          # Verb list with language badges
│   └── {verb}/
│       ├── en.html         # English origin
│       └── ru.html         # Russian origin
└── en/                     # English (no variant needed)
    ├── index.html
    └── {verb}/
        ├── pt.html         # Portuguese origin
        └── ru.html         # Russian origin
```

## Supported languages

Target languages (what users learn):
- `en` — English 🇬🇧
- `pt-eu` — Portuguese (European) 🇵🇹

Origin languages (user's native language):
- `en` — English 🇬🇧
- `pt` — Portuguese 🇵🇹
- `ru` — Russian 🇷🇺

## Page requirements

Each verb page must have:
- 100 phrases sorted by frequency (most common first)
- All tenses (language-specific)
- Questions, negations, polite requests, common expressions
- Verb forms highlighted in target language
- Tense tags for each phrase
- Search functionality
- Show/hide all buttons
- Dark theme, mobile-friendly
- Back link to verb list

### English tenses
Present, Past (could/was able to), Future (will be able to), Conditional, Polite, Permission, Expression

### Portuguese tenses
Presente, Pretérito Imperfeito, Pretérito Perfeito, Futuro, Condicional, Presente do Conjuntivo, Imperfeito do Conjuntivo

## When adding new verb

1. Create `{lang}/{verb}/{origin}.html` for each origin language
2. Update `{lang}/index.html` to add verb card with language badges
3. Follow existing file structure (copy from existing verb as template)
4. Update README.md if adding new language

## Commits

Focus on why, not what. Keep it concise.
