require 'fileutils'
require 'tv_show'

class TVShowOrganizer
  include FileUtils
  
  attr_accessor :extension, :source_directory, :destination_directory, :processed_directory, :delete_processed_files, :recursive
  
  def sanitize_file_name(text)
    text.nil? ? nil : text.gsub(/[\/\\\?%\*:|"<>]/, '')
  end
  
  def recursive=(new_value)
    @recursive = new_value
  end
  
  def recursive?
    @recursive || false
  end
  
  def fix_episode_names(path, test_run = false)
    FileUtils.cd(path)
    
    Dir['**/Episode*.*'].each do |file_name|
      show = TVShow.new_from_path(File.join(path, file_name))
      
      new_file_name = "#{show.episode.to_s.rjust(2, '0')} #{sanitize_file_name(show.tv_rage.episode_name)}#{show.extension}"
      new_path = File.join(File.dirname(file_name), new_file_name)
      
      puts "Renaming #{file_name} to #{new_path}."
      
      File.rename(file_name, new_path) unless test_run
    end
  end
  
  def organize
    # Make sure the backup directory exists
    makedirs(@processed_directory) unless @processed_directory.nil?

    # Change to the source directory
    cd(@source_directory)
    
    file_pattern = "*.#{@extension}"
    file_pattern = "**/" + file_pattern if recursive?

    Dir[file_pattern].each do |file_name|
      show = TVShow.new(File.basename(file_name))
      path = nil

      puts "Processing #{file_name}"
      
      show_name = show.tv_rage.show_name || show.show_name
      show_name = sanitize_file_name show_name

      if show.episode.nil?
        if show.date.nil?
          puts "Skipping #{file_name}"
          next
        else
          path = "#{@destination_directory}/#{show_name}/#{show.date.strftime('%Y')}/#{show.date.strftime('%m')}/#{show.date.strftime('%d')}.#{@extension}"
        end
      else
        puts "Looking up episode name"
        episode_name   = show.tv_rage.episode_name
        episode_name   = sanitize_file_name episode_name
        episode_number = show.episode.to_s.rjust(2, "0")

        if episode_name
          path = "#{@destination_directory}/#{show_name}/Season #{show.season}/#{episode_number} #{episode_name}.#{@extension}"
        else
          path = "#{@destination_directory}/#{show_name}/Season #{show.season}/Episode #{episode_number}.#{@extension}"
        end
      end

      directory = File.dirname(path)
      new_file_name = File.basename(path)

      puts "Creating directories #{directory}"
      makedirs(directory)

      unless File.exists?(path)
        if @delete_processed_files
          puts "Moving file to #{path}"
          mv(file_name, path)
          
          if File.exists?(file_name)
            puts "Removing file #{file_name}"
            rm(file_name)
          end
        else
          puts "Copying file to #{path}"
          copy_file(file_name, path)

          puts "Moving #{file_name} to processed directory"
          mv(file_name, "#{@processed_directory}/#{File.basename(file_name)}")
        end
      else
        puts "File already exists in destination."
      end
    end
  end
end
