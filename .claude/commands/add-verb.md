# Add new verb

Add a new verb to the practice system.

## Input

$ARGUMENTS - format: "{target} {verb}" (e.g., "pt-eu fazer", "en can")

## Steps

1. Parse target language and verb from input
2. Create `src/data/{target}/{verb}.yml` with:
   - slug, name, meaning, verb_forms
   - phrases for each origin language (100 each)
3. Add verb to `src/data/{target}/index.yml`
4. Run `ruby build.rb`

## YAML structure

For pt-eu (learning Portuguese):
```yaml
slug: verb-name
name: "🇵🇹 Verb NAME"
meaning: to do something
verb_forms: [conjugated, forms, here]
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

For en (learning English):
```yaml
slug: verb-name
name: "🇬🇧 Verb NAME"
meaning: to do something
verb_forms: [verb, forms, here]
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

## Phrase requirements

- 100 phrases per origin language, sorted by frequency
- Cover all tenses for target language
- Include: statements, negations, questions, polite requests, expressions
- Practical, everyday usage

## Tenses

Portuguese: Presente, Pretérito Imperfeito, Pretérito Perfeito, Futuro, Condicional, Presente do Conjuntivo, Imperfeito do Conjuntivo

English: Present, Past, Future, Conditional, Polite, Permission, Expression
