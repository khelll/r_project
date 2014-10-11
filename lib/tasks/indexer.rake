namespace :indexing do  
  desc 'Index packages'
  task perform: :environment do
    options = {}
    options.merge!(max_fetch: ENV['MAX_PACKAGES'].to_i) if ENV['MAX_PACKAGES']
    RIndexer::Indexer.perform(options)
  end
end
