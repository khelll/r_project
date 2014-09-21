namespace :syncing do  
  desc 'Sync packages'
  task perform: :environment do
    options = {}
    options.merge!(max_fetch: ENV['MAX_PACKAGES'].to_i) if ENV['MAX_PACKAGES']
    RSyncer::Syncer.perform(options)
  end
end
