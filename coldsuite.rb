#!/usr/bin/env ruby

# frozen_string_literal: true

require 'fileutils'
require 'json'

$cache_downloads = true # Set this to false to always download everything each time
$tool_folder = './tools'
$index_template = File.read('./index_template.html')
$TOOLS = JSON.parse(File.read('./tools.json'), symbolize_names: true)

def install
  print_header
  setup_tool_folder
  download_tools
  create_index
  print_instructions
end

def setup_tool_folder
  puts "Tool Suite will be installed into: '#{$tool_folder}'"
  puts
  print 'Press enter to continue...'
  STDIN.readline
  puts
  remove_existing_tool_folder if Dir.exist?($tool_folder)
end

# Remove existing tools folder for complete rebuild
def remove_existing_tool_folder
  puts "Warning: '#{$tool_folder}' already exists. This will be removed and recreated!"
  print "  Is this ok? (type 'yes' if so) : "
  exit unless STDIN.readline.strip == 'yes'
  FileUtils.remove_dir($tool_folder)
  puts
end

def download_tools
  $TOOLS.each do |tool|
    download_tool(tool)
  end
end

def download_tool(tool)
  file = tool[:src].split('/')[-1]
  fullpath = File.join($tool_folder, tool[:folder])
  puts " • Installing #{tool[:name]} to '#{fullpath}'"
  FileUtils.mkdir_p(fullpath)

  # Delete the downloaded file if it exists and we aren't caching
  File.unlink(file) if !File.exist?(file) && !$cache_downloads

  unless File.exist?(file)
    puts "   • Downloading #{tool[:src]}"
    # TODO: Check MD5 hashes here that are entered into tools.json
    # TODO: Make this portable
    `wget -q --show-progress #{tool[:src]}`
  end

  # Copy or unzip the file to the destination
  if tool[:src].end_with?('.zip')
    # TODO: Make this portable
    `unzip -d #{fullpath} #{file}`
  else
    FileUtils.copy(file, fullpath)
  end
end

def tool_links
  $TOOLS.map do |tool|
    tool_file = if tool[:src].end_with?('.zip')
                  'index.html'
                else
                  tool[:src].split('/')[-1]
                end
    "<hr /><h2><a href='#{File.join(tool[:folder], tool_file)}'>#{tool[:name]}</a></h2>"
  end.join("\n")
end

def create_index
  file = File.join($tool_folder, 'index.html')
  puts " • Writing index file: #{file}"
  html = $index_template.gsub('__TOOL_LINKS_HERE__', tool_links)
  File.unlink(file) if File.exist?(file)
  File.open(file, 'w') do |f|
    f.write(html)
  end
end

def print_instructions
  file = File.join($tool_folder, 'index.html')
  puts <<~INSTRUCTIONS

    Done.

    Copy the folder: '#{$tool_folder}' to your offline computer and open '#{file}'

    To test on this computer browse to:
      file://#{File.expand_path(file)}
INSTRUCTIONS
end

def print_header
  puts '

                ____        _      _   ____          _  _
               / ___| ___  | |  __| | / ___|  _   _ (_)| |_  ___
              | |    / _ \ | | / _` | \___ \ | | | || || __|/ _ \
              | |___| (_) || || (_| |  ___) || |_| || || |_|  __/
               \____|\___/ |_| \__,_| |____/  \__,_||_| \__|\___|

             Curated cold storage and offline cryptocurrency tools
            _______________________________________________________

Cold Suite will download various offline web based tools into a bundled package
you can move to an air-gapped computer for proper, safe cold storage purposes.

IMPORTANT: Please take a careful look at all the files in this repo, in
particular tools.json, to verify the source and trustworthiness of each tool and
the legitimacy of the code that packages them together!

'
end
install
