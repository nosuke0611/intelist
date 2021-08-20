# config valid for current version and patch releases of Capistrano
lock "3.16.0"

set :application, "intelist"
set :repo_url, "git@github.com:nosuke0611/intelist.git"

set :branch, 'main'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/rails/intelist"

# Default value for :linked_files is [] (シンボリックリンク用のファイル)
set :linked_files, %w[config/master.key]
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/settings.yml', '.env')

# Default value for linked_dirs is []（シンボリック用のフォルダ）
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for keep_releases is 5
set :keep_releases, 5

set :rbenv_ruby, '3.0.2'

set :log_level, :debug

# プロセス番号を記載したファイルの場所
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

# Unicornの設定ファイルの場所
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.prod.rb" }

# デプロイ処理が終わった後、Unicornを再起動するための記述
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end