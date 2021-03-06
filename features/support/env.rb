# encoding: utf-8

require 'fileutils'
require 'filemagic'

TAGS_MATRIX = {
  "danbooru" => "touhou konpaku_youmu",
  "konachan" => "robotics;notes",
  "e621" => "touhou",
  "behoimi" => "touhou",
  "yandere" => "touhou"
}
POOLS_MATRIX = {
  "danbooru" => {"id" => 364, "name" => "Nanoha/Fate doujin"},
  "konachan" => {"id" => 4, "name" => "Clannad Wallpapers (Zoomlayer + Logo + Name)"},
  "e621" => {"id" => 5412, "name" => "MLP: Still Images & Complete Animation Loops"},
  "behoimi" => {"id" => 13, "name" => "Rumpalicious!"},
  "yandere" => {"id" => 1184, "name" => "E☆2 Etsu Magazine vol. 22 2009-12"}
}
SPECIAL_MATRIX = {
  "danbooru" => "user:randeel",
  "konachan" => "vote:3:opai",
  "e621" => "user:slyroon",
  "behoimi" => "user:darkgray",
  "yandere" => "date:2016-05-14"
}
PER_PAGE = 3
PAGES = 2
POSTS_COUNT = PER_PAGE * PAGES

# Clean all files before and after each scenario
Before do
  clean_files
end

After do
  clean_files
end

def clean_files
  pools_dirs = POOLS_MATRIX.map { |k,v| v["name"] }
  (TAGS_MATRIX.values + pools_dirs + SPECIAL_MATRIX.values).each do |dir|
    actual_dir1 = sanitize_filename(dir, false)
    actual_dir2 = sanitize_filename(dir, true)
    FileUtils.rm_r(actual_dir1) if Dir.exists?(actual_dir1)
    FileUtils.rm_r(actual_dir2) if Dir.exists?(actual_dir2)
  end
end

def list_files(dir, pattern = "*")
  Dir.chdir(dir) do
    Dir[pattern]
  end
end

def sanitize_filename(filename, pool = false)
  result = filename.gsub(/[\?\*\/\\\:]/, "_")
  space_sub = pool ? "_" : "+"
  result.gsub(" ", space_sub)
end
