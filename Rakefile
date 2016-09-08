require 'yard'
YARD::Rake::YardocTask.new

namespace :yard do
  desc 'Publish docs'
  task publish: :yard do
    system 'git stash'
    system 'git checkout gh-pages'
    system 'cp -r doc/ .'
    system 'git add .'
    system 'git commit -m "Update documentation"'
    system 'git push origin gh-pages'
    system 'git checkout master'
    system 'git stash pop'
  end
end

namespace :travis do
  task :install do
    case ENV['MARKET_TOWN']
    when 'brochure'
      system 'gimme 1.7'
      system 'mkdir -p $GOPATH/src && cp -r brochure/ $GOPATH/src/brochure/'
      system 'go get -t ./...', chdir: "#{ENV['GOPATH']}/src/brochure"
    when 'checkout'
      env = case ENV['RAKE_TASK']
            when 'rubocop', 'common_spec'
              { 'BUNDLE_GEMFILE' => './Gemfile' }
            when 'spree_spec'
              { 'BUNDLE_GEMFILE' => './Gemfile.spree.rb' }
            when 'solidus_spec'
              { 'BUNDLE_GEMFILE' => './Gemfile.solidus.rb' }
            end
      system env, 'bundle install', chdir: 'checkout'
    end
  end

  task :script do
    case ENV['MARKET_TOWN']
    when 'brochure'
      system 'go test -v', chdir: "#{ENV['GOPATH']}/src/brochure"
    when 'checkout'
      system("bundle exec rake #{ENV['RAKE_TASK']}", chdir: 'checkout')
    end
  end
end
