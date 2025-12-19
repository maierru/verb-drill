# Add new verb

Add a new verb practice page for all supported origin languages.

## Input

$ARGUMENTS - format: "{language} {verb}" (e.g., "portuguese fazer", "pt-eu ser")

## Steps

1. Parse input to get target language and verb
2. Map language name to code if needed (portuguese → pt-eu)
3. Create folder: `{lang-code}/{verb}/`
4. Generate `en.html` with 100 English→Portuguese phrases
5. Generate `ru.html` with 100 Russian→Portuguese phrases
6. Update `{lang-code}/index.html` to add verb card with badges

## Generation prompt for each page

Create 100 popular phrases using the verb "{verb}" in European Portuguese, sorted by frequency.

Requirements:
- Cover all tenses: Presente, Pretérito Imperfeito, Pretérito Perfeito, Futuro, Condicional, Presente do Conjuntivo, Imperfeito do Conjuntivo
- Include: statements, negations, questions, polite requests, common expressions
- Phrases should be practical, everyday usage
- Highlight all verb conjugation forms

Use the existing `pt-eu/poder/en.html` and `pt-eu/poder/ru.html` as templates - copy structure exactly, only change:
- Title and header (verb name)
- Phrases array (new verb conjugations)
- highlightVerb function (new verb forms)
- Footer text

## Language mapping

- portuguese, pt-eu → pt-eu (European Portuguese)
- brazilian, pt-br → pt-br (Brazilian Portuguese)
- spanish, es-es → es-es (Castilian Spanish)
