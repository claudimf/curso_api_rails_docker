# frozen_string_literal:true

SIDEKIQ_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/sidekiq.yml")).result)[Rails.env]

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{SIDEKIQ_CONFIG['host']}:#{SIDEKIQ_CONFIG['port']}/#{SIDEKIQ_CONFIG['db_num']}",
    password: SIDEKIQ_CONFIG['password'],
    port: SIDEKIQ_CONFIG['port'],
    timeout: SIDEKIQ_CONFIG['timeout']
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{SIDEKIQ_CONFIG['host']}:#{SIDEKIQ_CONFIG['port']}/#{SIDEKIQ_CONFIG['db_num']}",
    password: SIDEKIQ_CONFIG['password'],
    port: SIDEKIQ_CONFIG['port'],
    timeout: SIDEKIQ_CONFIG['timeout']
  }
end

# Configurar scheduler
schedule_file = "config/schedule.yml"
if File.exist?(schedule_file) && Sidekiq.server?
   Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
