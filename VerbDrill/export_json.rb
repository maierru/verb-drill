#!/usr/bin/env ruby
# frozen_string_literal: true

# Exports YAML verb data to JSON for iOS app
# Usage: ruby export_json.rb

require 'yaml'
require 'json'
require 'fileutils'

SOURCE_DIR = File.expand_path('../src/data', __dir__)
OUTPUT_DIR = File.expand_path('VerbDrill/Resources', __dir__)

# Target languages (what user learns)
TARGET_LANGUAGES = %w[pt-eu en es de fr].freeze

# Mapping from origin language key in YAML to standard code
ORIGIN_LANG_MAP = {
  'en' => 'en',
  'ru' => 'ru',
  'pt' => 'pt',
  'de' => 'de',
  'fr' => 'fr',
  'es' => 'es'
}.freeze

def load_yaml(path)
  YAML.safe_load(File.read(path), permitted_classes: [Symbol])
rescue StandardError => e
  puts "Error loading #{path}: #{e.message}"
  nil
end

def target_key(target_lang)
  case target_lang
  when 'pt-eu' then 'pt'
  when 'en' then 'en'
  when 'es' then 'es'
  when 'de' then 'de'
  when 'fr' then 'fr'
  else target_lang
  end
end

def export_verb(target_lang, verb_slug)
  verb_path = File.join(SOURCE_DIR, target_lang, "#{verb_slug}.yml")
  return nil unless File.exist?(verb_path)

  verb_data = load_yaml(verb_path)
  return nil unless verb_data

  target_field = target_key(target_lang)

  # Convert phrases to simplified format
  phrases = {}
  (verb_data['phrases'] || {}).each do |origin_lang, origin_phrases|
    next unless ORIGIN_LANG_MAP[origin_lang]

    phrases[origin_lang] = origin_phrases.map do |p|
      {
        'origin' => p[origin_lang],
        'target' => p[target_field],
        'tense' => p['tense'] || ''
      }
    end.compact
  end

  {
    'slug' => verb_data['slug'],
    'name' => verb_data['name'],
    'meaning' => verb_data['meaning'],
    'verb_forms' => verb_data['verb_forms'] || [],
    'phrases' => phrases
  }
end

def export_index(target_lang)
  index_path = File.join(SOURCE_DIR, target_lang, 'index.yml')
  return nil unless File.exist?(index_path)

  index_data = load_yaml(index_path)
  return nil unless index_data

  {
    'title' => index_data['title'] || '',
    'h1' => index_data['h1'] || '',
    'subtitle' => index_data['subtitle'] || '',
    'verbs' => (index_data['verbs'] || []).map do |v|
      {
        'name' => v['name'],
        'meaning' => v['meaning'],
        'slug' => v['slug']
      }
    end
  }
end

def main
  FileUtils.mkdir_p(OUTPUT_DIR)

  # Export main data.json with all language indexes
  all_data = { 'languages' => {} }

  TARGET_LANGUAGES.each do |lang|
    index = export_index(lang)
    next unless index

    all_data['languages'][lang] = index
    puts "Exported index for #{lang}: #{index['verbs'].count} verbs"
  end

  # Write main index
  data_path = File.join(OUTPUT_DIR, 'data.json')
  File.write(data_path, JSON.pretty_generate(all_data))
  puts "Wrote #{data_path}"

  # Export individual verb files
  verb_count = 0
  TARGET_LANGUAGES.each do |lang|
    index = export_index(lang)
    next unless index

    index['verbs'].each do |verb_summary|
      verb = export_verb(lang, verb_summary['slug'])
      next unless verb

      verb_path = File.join(OUTPUT_DIR, "#{lang}_#{verb_summary['slug']}.json")
      File.write(verb_path, JSON.generate(verb))
      verb_count += 1
    end
  end

  puts "Exported #{verb_count} verb files"
  puts "Done! Files written to #{OUTPUT_DIR}"
end

main
