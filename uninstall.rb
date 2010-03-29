# Remove the assets from RAILS_ROOT
RAILS_ROOT = File.join(File.dirname(__FILE__), '../../../')
FileUtils.unlink File.join(RAILS_ROOT, 'app', 'stylesheets', 'semantic_forms.less')
FileUtils.unlink File.join(RAILS_ROOT, 'config', 'locales', 'form_builder', 'en.yml')
FileUtils.unlink File.join(RAILS_ROOT, 'public', 'images', '16x16_spinner.gif')
FileUtils.unlink File.join(RAILS_ROOT, 'public', 'stylesheets', 'semantic_forms.css')
