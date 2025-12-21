#!/usr/bin/env ruby

require 'yaml'
require 'erb'
require 'json'
require 'fileutils'

Dir.chdir(__dir__)

# Labels by origin language and target language
# Key format: "origin_target" e.g. "en_pt" = English user learning Portuguese
LABELS = {
  # Learning Portuguese (pt-eu)
  'en_pt' => {
    back: '← Back to verb list',
    search: 'Search phrases...',
    show_all: 'Show all translations',
    hide_all: 'Hide all translations',
    showing: 'Showing',
    of: 'of',
    phrases: 'phrases',
    target: 'European Portuguese',
    footer_prefix: 'European Portuguese Practice —'
  },
  'ru_pt' => {
    back: '← Назад к списку глаголов',
    search: '🔍 Поиск по фразам...',
    show_all: 'Показать все переводы',
    hide_all: 'Скрыть все переводы',
    showing: 'Показано',
    of: 'из',
    phrases: 'фраз',
    target: 'Português Europeu',
    footer_prefix: 'Практика европейского португальского —'
  },
  # Learning English (en)
  'ru_en' => {
    back: '← Назад к списку глаголов',
    search: '🔍 Поиск по фразам...',
    show_all: 'Показать все переводы',
    hide_all: 'Скрыть все переводы',
    showing: 'Показано',
    of: 'из',
    phrases: 'фраз',
    target: 'English',
    footer_prefix: 'Практика английского —'
  },
  'pt_en' => {
    back: '← Voltar para lista de verbos',
    search: 'Pesquisar frases...',
    show_all: 'Mostrar todas traduções',
    hide_all: 'Esconder todas traduções',
    showing: 'Mostrando',
    of: 'de',
    phrases: 'frases',
    target: 'English',
    footer_prefix: 'English Practice —'
  },
  # Learning German (de)
  'en_de' => {
    back: '← Back to verb list',
    search: 'Search phrases...',
    show_all: 'Show all translations',
    hide_all: 'Hide all translations',
    showing: 'Showing',
    of: 'of',
    phrases: 'phrases',
    target: 'German',
    footer_prefix: 'German Practice —'
  },
  'ru_de' => {
    back: '← Назад к списку глаголов',
    search: '🔍 Поиск по фразам...',
    show_all: 'Показать все переводы',
    hide_all: 'Скрыть все переводы',
    showing: 'Показано',
    of: 'из',
    phrases: 'фраз',
    target: 'Deutsch',
    footer_prefix: 'Практика немецкого —'
  },
  'pt_de' => {
    back: '← Voltar para lista de verbos',
    search: 'Pesquisar frases...',
    show_all: 'Mostrar todas traduções',
    hide_all: 'Esconder todas traduções',
    showing: 'Mostrando',
    of: 'de',
    phrases: 'frases',
    target: 'Deutsch',
    footer_prefix: 'Prática de alemão —'
  },
  # Learning French (fr)
  'en_fr' => {
    back: '← Back to verb list',
    search: 'Search phrases...',
    show_all: 'Show all translations',
    hide_all: 'Hide all translations',
    showing: 'Showing',
    of: 'of',
    phrases: 'phrases',
    target: 'French',
    footer_prefix: 'French Practice —'
  },
  'ru_fr' => {
    back: '← Назад к списку глаголов',
    search: '🔍 Поиск по фразам...',
    show_all: 'Показать все переводы',
    hide_all: 'Скрыть все переводы',
    showing: 'Показано',
    of: 'из',
    phrases: 'фраз',
    target: 'Français',
    footer_prefix: 'Практика французского —'
  },
  'pt_fr' => {
    back: '← Voltar para lista de verbos',
    search: 'Pesquisar frases...',
    show_all: 'Mostrar todas traduções',
    hide_all: 'Esconder todas traduções',
    showing: 'Mostrando',
    of: 'de',
    phrases: 'frases',
    target: 'Français',
    footer_prefix: 'Prática de francês —'
  },
  # German as origin language
  'de_pt' => {
    back: '← Zurück zur Verbliste',
    search: 'Phrasen suchen...',
    show_all: 'Alle Übersetzungen anzeigen',
    hide_all: 'Alle Übersetzungen ausblenden',
    showing: 'Zeige',
    of: 'von',
    phrases: 'Phrasen',
    target: 'Europäisches Portugiesisch',
    footer_prefix: 'Portugiesisch-Übung —'
  },
  'de_en' => {
    back: '← Zurück zur Verbliste',
    search: 'Phrasen suchen...',
    show_all: 'Alle Übersetzungen anzeigen',
    hide_all: 'Alle Übersetzungen ausblenden',
    showing: 'Zeige',
    of: 'von',
    phrases: 'Phrasen',
    target: 'Englisch',
    footer_prefix: 'Englisch-Übung —'
  },
  'de_fr' => {
    back: '← Zurück zur Verbliste',
    search: 'Phrasen suchen...',
    show_all: 'Alle Übersetzungen anzeigen',
    hide_all: 'Alle Übersetzungen ausblenden',
    showing: 'Zeige',
    of: 'von',
    phrases: 'Phrasen',
    target: 'Französisch',
    footer_prefix: 'Französisch-Übung —'
  },
  # French as origin language
  'fr_pt' => {
    back: '← Retour à la liste des verbes',
    search: 'Rechercher des phrases...',
    show_all: 'Afficher toutes les traductions',
    hide_all: 'Masquer toutes les traductions',
    showing: 'Affichage',
    of: 'sur',
    phrases: 'phrases',
    target: 'Portugais européen',
    footer_prefix: 'Pratique du portugais —'
  },
  'fr_en' => {
    back: '← Retour à la liste des verbes',
    search: 'Rechercher des phrases...',
    show_all: 'Afficher toutes les traductions',
    hide_all: 'Masquer toutes les traductions',
    showing: 'Affichage',
    of: 'sur',
    phrases: 'phrases',
    target: 'Anglais',
    footer_prefix: "Pratique de l'anglais —"
  },
  'fr_de' => {
    back: '← Retour à la liste des verbes',
    search: 'Rechercher des phrases...',
    show_all: 'Afficher toutes les traductions',
    hide_all: 'Masquer toutes les traductions',
    showing: 'Affichage',
    of: 'sur',
    phrases: 'phrases',
    target: 'Allemand',
    footer_prefix: "Pratique de l'allemand —"
  },
  # Learning Spanish (es)
  'en_es' => {
    back: '← Back to verb list',
    search: 'Search phrases...',
    show_all: 'Show all translations',
    hide_all: 'Hide all translations',
    showing: 'Showing',
    of: 'of',
    phrases: 'phrases',
    target: 'Spanish',
    footer_prefix: 'Spanish Practice —'
  },
  'ru_es' => {
    back: '← Назад к списку глаголов',
    search: '🔍 Поиск по фразам...',
    show_all: 'Показать все переводы',
    hide_all: 'Скрыть все переводы',
    showing: 'Показано',
    of: 'из',
    phrases: 'фраз',
    target: 'Español',
    footer_prefix: 'Практика испанского —'
  },
  'pt_es' => {
    back: '← Voltar para lista de verbos',
    search: 'Pesquisar frases...',
    show_all: 'Mostrar todas traduções',
    hide_all: 'Esconder todas traduções',
    showing: 'Mostrando',
    of: 'de',
    phrases: 'frases',
    target: 'Español',
    footer_prefix: 'Prática de espanhol —'
  },
  'de_es' => {
    back: '← Zurück zur Verbliste',
    search: 'Phrasen suchen...',
    show_all: 'Alle Übersetzungen anzeigen',
    hide_all: 'Alle Übersetzungen ausblenden',
    showing: 'Zeige',
    of: 'von',
    phrases: 'Phrasen',
    target: 'Spanisch',
    footer_prefix: 'Spanisch-Übung —'
  },
  'fr_es' => {
    back: '← Retour à la liste des verbes',
    search: 'Rechercher des phrases...',
    show_all: 'Afficher toutes les traductions',
    hide_all: 'Masquer toutes les traductions',
    showing: 'Affichage',
    of: 'sur',
    phrases: 'phrases',
    target: 'Espagnol',
    footer_prefix: "Pratique de l'espagnol —"
  }
}

# Load site config first (needed for SEO)
site = YAML.load_file('src/data/site.yml')
site_url = site['site_url']
sitemap_urls = []

# Load templates
verb_template = ERB.new(File.read('src/templates/verb.html.erb'), trim_mode: '-')
index_template = ERB.new(File.read('src/templates/index.html.erb'), trim_mode: '-')

def build_verb_pages(lang_folder, target_lang, origins, verb_template, site_url, sitemap_urls)
  Dir.glob("src/data/#{lang_folder}/*.yml").each do |data_file|
    next if data_file.include?('index.yml')

    data = YAML.load_file(data_file)
    verb_slug = data['slug']

    FileUtils.mkdir_p("#{lang_folder}/#{verb_slug}")

    # Collect available origins for this verb (for hreflang)
    available_origins = origins.select { |o| data['phrases'][o] && !data['phrases'][o].empty? }

    origins.each do |origin|
      phrases = data['phrases'][origin]
      next if phrases.nil? || phrases.empty?

      labels = LABELS["#{origin}_#{target_lang}"]
      verb_forms = data['verb_forms']

      # Template variables
      if origin == 'en'
        title = "Verb #{data['name'].upcase} — #{phrases.length} Phrases"
        subtitle = "#{data['meaning']} — #{phrases.length} phrases"
        meta_description = "Practice #{data['name']} conjugation with #{phrases.length} real-world phrases. Learn #{labels[:target]} verb forms and usage."
      elsif origin == 'ru'
        title = "Глагол #{data['name'].upcase} — #{phrases.length} фраз"
        subtitle = "#{data['meaning']} — #{phrases.length} фраз"
        meta_description = "Практика спряжения #{data['name']} с #{phrases.length} фразами. Изучайте формы глагола #{labels[:target]}."
      elsif origin == 'de'
        title = "Verb #{data['name'].upcase} — #{phrases.length} Sätze"
        subtitle = "#{data['meaning']} — #{phrases.length} Sätze"
        meta_description = "Üben Sie die Konjugation von #{data['name']} mit #{phrases.length} Sätzen. Lernen Sie #{labels[:target]} Verbformen."
      elsif origin == 'fr'
        title = "Verbe #{data['name'].upcase} — #{phrases.length} phrases"
        subtitle = "#{data['meaning']} — #{phrases.length} phrases"
        meta_description = "Pratiquez la conjugaison de #{data['name']} avec #{phrases.length} phrases. Apprenez les formes verbales en #{labels[:target]}."
      else
        title = "Verbo #{data['name'].upcase} — #{phrases.length} Frases"
        subtitle = "#{data['meaning']} — #{phrases.length} frases"
        meta_description = "Pratique a conjugação de #{data['name']} com #{phrases.length} frases. Aprenda as formas verbais em #{labels[:target]}."
      end

      h1 = data['name']
      origin_key = origin
      target_key = target_lang
      footer = "#{labels[:footer_prefix]} #{verb_slug.upcase}"
      conjugation = data['conjugation']

      # SEO variables
      canonical_url = "#{site_url}/#{lang_folder}/#{verb_slug}/#{origin}.html"
      alternate_langs = available_origins.map { |o| { lang: o, url: "#{site_url}/#{lang_folder}/#{verb_slug}/#{o}.html" } }

      html = verb_template.result(binding)

      output_path = "#{lang_folder}/#{verb_slug}/#{origin}.html"
      File.write(output_path, html)
      sitemap_urls << { url: canonical_url, priority: '0.6' }
      puts "Built: #{output_path}"
    end
  end
end

# Build pt-eu verb pages (learning Portuguese from en/ru/de/fr)
build_verb_pages('pt-eu', 'pt', %w[en ru de fr], verb_template, site_url, sitemap_urls)

# Build en verb pages (learning English from ru/pt/de/fr)
build_verb_pages('en', 'en', %w[ru pt de fr], verb_template, site_url, sitemap_urls)

# Build de verb pages (learning German from en/ru/pt/fr)
build_verb_pages('de', 'de', %w[en ru pt fr], verb_template, site_url, sitemap_urls)

# Build fr verb pages (learning French from en/ru/pt/de)
build_verb_pages('fr', 'fr', %w[en ru pt de], verb_template, site_url, sitemap_urls)

# Build es verb pages (learning Spanish from en/ru/pt/de/fr)
build_verb_pages('es', 'es', %w[en ru pt de fr], verb_template, site_url, sitemap_urls)

# Build pt-eu index
if File.exist?('src/data/pt-eu/index.yml')
  index_data = YAML.load_file('src/data/pt-eu/index.yml')
  lang_folder = 'pt-eu'

  title = index_data['title']
  h1 = index_data['h1']
  subtitle = index_data['subtitle']
  back_link = '← Back to languages'
  footer = 'Verb Drill — Open source language practice'
  meta_description = "Learn European Portuguese verbs with #{index_data['verbs'].length * 100} real-world phrases. Practice conjugations interactively."
  canonical_url = "#{site_url}/pt-eu/"

  verbs = index_data['verbs'].map do |v|
    {
      name: v['name'],
      meaning: "#{v['meaning']} — 100 phrases",
      slug: v['slug'],
      langs: [
        { code: 'en', label: '🇬🇧 EN' },
        { code: 'ru', label: '🇷🇺 RU' },
        { code: 'de', label: '🇩🇪 DE' },
        { code: 'fr', label: '🇫🇷 FR' }
      ]
    }
  end

  html = index_template.result(binding)
  File.write('pt-eu/index.html', html)
  sitemap_urls << { url: canonical_url, priority: '0.8' }
  puts "Built: pt-eu/index.html"
end

# Build en index
if File.exist?('src/data/en/index.yml')
  index_data = YAML.load_file('src/data/en/index.yml')
  lang_folder = 'en'

  title = index_data['title']
  h1 = index_data['h1']
  subtitle = index_data['subtitle']
  back_link = '← Back to languages'
  footer = 'Verb Drill — Open source language practice'
  meta_description = "Learn English verbs with #{index_data['verbs'].length * 100} real-world phrases. Practice conjugations interactively."
  canonical_url = "#{site_url}/en/"

  verbs = index_data['verbs'].map do |v|
    {
      name: v['name'],
      meaning: "#{v['meaning']} — 100 phrases",
      slug: v['slug'],
      langs: [
        { code: 'ru', label: '🇷🇺 RU' },
        { code: 'pt', label: '🇵🇹 PT' },
        { code: 'de', label: '🇩🇪 DE' },
        { code: 'fr', label: '🇫🇷 FR' }
      ]
    }
  end

  html = index_template.result(binding)
  File.write('en/index.html', html)
  sitemap_urls << { url: canonical_url, priority: '0.8' }
  puts "Built: en/index.html"
end

# Build de index
if File.exist?('src/data/de/index.yml')
  index_data = YAML.load_file('src/data/de/index.yml')
  lang_folder = 'de'

  title = index_data['title']
  h1 = index_data['h1']
  subtitle = index_data['subtitle']
  back_link = '← Back to languages'
  footer = 'Verb Drill — Open source language practice'
  meta_description = "Lernen Sie deutsche Verben mit Beispielsätzen. Üben Sie Konjugationen interaktiv."
  canonical_url = "#{site_url}/de/"

  verbs = index_data['verbs'].map do |v|
    {
      name: v['name'],
      meaning: v['meaning'],
      slug: v['slug'],
      langs: [
        { code: 'en', label: '🇬🇧 EN' },
        { code: 'ru', label: '🇷🇺 RU' },
        { code: 'pt', label: '🇵🇹 PT' },
        { code: 'fr', label: '🇫🇷 FR' }
      ]
    }
  end

  html = index_template.result(binding)
  File.write('de/index.html', html)
  sitemap_urls << { url: canonical_url, priority: '0.8' }
  puts "Built: de/index.html"
end

# Build fr index
if File.exist?('src/data/fr/index.yml')
  index_data = YAML.load_file('src/data/fr/index.yml')
  lang_folder = 'fr'

  title = index_data['title']
  h1 = index_data['h1']
  subtitle = index_data['subtitle']
  back_link = '← Back to languages'
  footer = 'Verb Drill — Open source language practice'
  meta_description = "Apprenez les verbes français avec des phrases réelles. Pratiquez les conjugaisons de manière interactive."
  canonical_url = "#{site_url}/fr/"

  verbs = index_data['verbs'].map do |v|
    {
      name: v['name'],
      meaning: v['meaning'],
      slug: v['slug'],
      langs: [
        { code: 'en', label: '🇬🇧 EN' },
        { code: 'ru', label: '🇷🇺 RU' },
        { code: 'pt', label: '🇵🇹 PT' },
        { code: 'de', label: '🇩🇪 DE' }
      ]
    }
  end

  html = index_template.result(binding)
  File.write('fr/index.html', html)
  sitemap_urls << { url: canonical_url, priority: '0.8' }
  puts "Built: fr/index.html"
end

# Build es index
if File.exist?('src/data/es/index.yml')
  index_data = YAML.load_file('src/data/es/index.yml')
  lang_folder = 'es'

  title = index_data['title']
  h1 = index_data['h1']
  subtitle = index_data['subtitle']
  back_link = '← Back to languages'
  footer = 'Verb Drill — Open source language practice'
  meta_description = "Aprende verbos en español con frases reales. Practica conjugaciones de forma interactiva."
  canonical_url = "#{site_url}/es/"

  verbs = index_data['verbs'].map do |v|
    {
      name: v['name'],
      meaning: v['meaning'],
      slug: v['slug'],
      langs: [
        { code: 'en', label: '🇬🇧 EN' },
        { code: 'ru', label: '🇷🇺 RU' },
        { code: 'pt', label: '🇵🇹 PT' },
        { code: 'de', label: '🇩🇪 DE' },
        { code: 'fr', label: '🇫🇷 FR' }
      ]
    }
  end

  html = index_template.result(binding)
  File.write('es/index.html', html)
  sitemap_urls << { url: canonical_url, priority: '0.8' }
  puts "Built: es/index.html"
end

# Build root index and README from site.yml (site already loaded at top)
name = site['name']
description = site['description']
tagline = site['tagline']
languages = site['languages']
origins = site['origins']
github_url = site['github_url']
phrases_per_verb = site['phrases_per_verb']

root_template = ERB.new(File.read('src/templates/root.html.erb'), trim_mode: '-')
html = root_template.result(binding)
File.write('index.html', html)
sitemap_urls << { url: "#{site_url}/", priority: '1.0' }
puts "Built: index.html"

readme_template = ERB.new(File.read('src/templates/readme.md.erb'), trim_mode: '-')
readme = readme_template.result(binding)
File.write('README.md', readme)
puts "Built: README.md"

# Generate sitemap.xml
sitemap_content = <<~XML
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
#{sitemap_urls.sort_by { |u| -u[:priority].to_f }.map { |u| "  <url>\n    <loc>#{u[:url]}</loc>\n    <priority>#{u[:priority]}</priority>\n  </url>" }.join("\n")}
</urlset>
XML
File.write('sitemap.xml', sitemap_content)
puts "Built: sitemap.xml (#{sitemap_urls.length} URLs)"

# Generate robots.txt
robots_content = <<~TXT
User-agent: *
Allow: /

Sitemap: #{site_url}/sitemap.xml
TXT
File.write('robots.txt', robots_content)
puts "Built: robots.txt"

total_pages = Dir.glob('pt-eu/*/*.html').count + Dir.glob('en/*/*.html').count + Dir.glob('de/*/*.html').count + Dir.glob('fr/*/*.html').count + Dir.glob('es/*/*.html').count
puts "\nDone! Built #{total_pages} verb pages"
