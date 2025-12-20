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
  }
}

# Load templates
verb_template = ERB.new(File.read('src/templates/verb.html.erb'), trim_mode: '-')
index_template = ERB.new(File.read('src/templates/index.html.erb'), trim_mode: '-')

def build_verb_pages(lang_folder, target_lang, origins, verb_template)
  Dir.glob("src/data/#{lang_folder}/*.yml").each do |data_file|
    next if data_file.include?('index.yml')

    data = YAML.load_file(data_file)
    verb_slug = data['slug']

    FileUtils.mkdir_p("#{lang_folder}/#{verb_slug}")

    origins.each do |origin|
      phrases = data['phrases'][origin]
      next if phrases.nil? || phrases.empty?

      labels = LABELS["#{origin}_#{target_lang}"]
      verb_forms = data['verb_forms']

      # Template variables
      if origin == 'en'
        title = "Verb #{data['name'].upcase} — #{phrases.length} Phrases"
        subtitle = "#{data['meaning']} — #{phrases.length} phrases"
      elsif origin == 'ru'
        title = "Глагол #{data['name'].upcase} — #{phrases.length} фраз"
        subtitle = "#{data['meaning']} — #{phrases.length} фраз"
      else
        title = "Verbo #{data['name'].upcase} — #{phrases.length} Frases"
        subtitle = "#{data['meaning']} — #{phrases.length} frases"
      end

      h1 = data['name']
      origin_key = origin
      target_key = target_lang
      footer = "#{labels[:footer_prefix]} #{verb_slug.upcase}"

      html = verb_template.result(binding)

      output_path = "#{lang_folder}/#{verb_slug}/#{origin}.html"
      File.write(output_path, html)
      puts "Built: #{output_path}"
    end
  end
end

# Build pt-eu verb pages (learning Portuguese from en/ru)
build_verb_pages('pt-eu', 'pt', %w[en ru], verb_template)

# Build en verb pages (learning English from ru/pt)
build_verb_pages('en', 'en', %w[ru pt], verb_template)

# Build pt-eu index
if File.exist?('src/data/pt-eu/index.yml')
  index_data = YAML.load_file('src/data/pt-eu/index.yml')

  title = index_data['title']
  h1 = index_data['h1']
  subtitle = index_data['subtitle']
  back_link = '← Back to languages'
  footer = 'Verb Drill — Open source language practice'

  verbs = index_data['verbs'].map do |v|
    {
      name: v['name'],
      meaning: "#{v['meaning']} — 100 phrases",
      slug: v['slug'],
      langs: [
        { code: 'en', label: '🇬🇧 EN' },
        { code: 'ru', label: '🇷🇺 RU' }
      ]
    }
  end

  html = index_template.result(binding)
  File.write('pt-eu/index.html', html)
  puts "Built: pt-eu/index.html"
end

# Build en index
if File.exist?('src/data/en/index.yml')
  index_data = YAML.load_file('src/data/en/index.yml')

  title = index_data['title']
  h1 = index_data['h1']
  subtitle = index_data['subtitle']
  back_link = '← Back to languages'
  footer = 'Verb Drill — Open source language practice'

  verbs = index_data['verbs'].map do |v|
    {
      name: v['name'],
      meaning: "#{v['meaning']} — 100 phrases",
      slug: v['slug'],
      langs: [
        { code: 'ru', label: '🇷🇺 RU' },
        { code: 'pt', label: '🇵🇹 PT' }
      ]
    }
  end

  html = index_template.result(binding)
  File.write('en/index.html', html)
  puts "Built: en/index.html"
end

total_pages = Dir.glob('pt-eu/*/*.html').count + Dir.glob('en/*/*.html').count
puts "\nDone! Built #{total_pages} verb pages"
