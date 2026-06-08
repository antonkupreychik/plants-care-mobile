source "https://rubygems.org"

# fastlane — автоматизация сборки и деплоя Android/iOS.
# Версия зафиксирована; мажорные обновления — отдельной задачей.
gem "fastlane", "~> 2.225"

# Плагины fastlane
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
