#!/usr/bin/env ruby

require 'yaml'
require 'erb'
require 'json'
require 'fileutils'

Dir.chdir(__dir__)

# Language-specific labels
LABELS = {
  'en' => {
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
  'ru' => {
    back: '← Назад к списку глаголов',
    search: '🔍 Поиск по фразам...',
    show_all: 'Показать все переводы',
    hide_all: 'Скрыть все переводы',
    showing: 'Показано',
    of: 'из',
    phrases: 'фраз',
    target: 'Português Europeu',
    footer_prefix: 'Практика европейского португальского —'
  }
}

# Load templates
verb_template = ERB.new(File.read('src/templates/verb.html.erb'), trim_mode: '-')
index_template = ERB.new(File.read('src/templates/index.html.erb'), trim_mode: '-')

# Build pt-eu verb pages
Dir.glob('src/data/pt-eu/*.yml').each do |data_file|
  next if data_file.include?('index.yml')

  data = YAML.load_file(data_file)
  verb_slug = data['slug']

  # Ensure output directory exists
  FileUtils.mkdir_p("pt-eu/#{verb_slug}")

  # Build for each origin language
  %w[en ru].each do |origin|
    phrases = data['phrases'][origin]
    next if phrases.nil? || phrases.empty?

    labels = LABELS[origin]
    verb_forms = data['verb_forms']

    # Template variables
    title = origin == 'en' ? "Verb #{data['name'].upcase} — 100 Phrases" : "Глагол #{data['name'].upcase} — 100 фраз"
    h1 = data['name']
    subtitle = origin == 'en' ? "#{data['meaning']} — #{phrases.length} phrases" : "#{data['meaning']} — #{phrases.length} фраз"
    origin_key = origin
    footer = "#{labels[:footer_prefix]} #{verb_slug.upcase}"

    # Render template
    html = verb_template.result(binding)

    # Write output
    output_path = "pt-eu/#{verb_slug}/#{origin}.html"
    File.write(output_path, html)
    puts "Built: #{output_path}"
  end
end

# Build pt-eu index
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

puts "\nDone! Built #{Dir.glob('pt-eu/*/*.html').count} verb pages + 1 index"
