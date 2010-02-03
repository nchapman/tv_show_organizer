require 'yaml'
require 'tv_show_organizer'

config = YAML::load(File.open('config.yml'))

organizer = TVShowOrganizer.new

organizer.source_directory = config['source_directory']
organizer.destination_directory = config['destination_directory']
organizer.delete_processed_files = config['delete_processed_files']
organizer.processed_directory = config['processed_directory']
organizer.extension = config['extension'] || 'avi'
organizer.recursive = config['recursive'] || false

organizer.organize