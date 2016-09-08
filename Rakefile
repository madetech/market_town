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

def set_gemfile_based_on_rake_task
  case ENV['RAKE_TASK']
  when 'rubocop', 'common_spec'
    ENV['BUNDLE_GEMFILE'] = "#{ENV['PWD']}/checkout/Gemfile"
  when 'spree_spec'
    ENV['BUNDLE_GEMFILE'] = "#{ENV['PWD']}/checkout/Gemfile.spree.rb"
  when 'solidus_spec'
    ENV['BUNDLE_GEMFILE'] = "#{ENV['PWD']}/checkout/Gemfile.solidus.rb"
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
      Bundler.with_clean_env do
        set_gemfile_based_on_rake_task
        system 'bundle install', chdir: 'checkout' or throw 'Could not install'
      end
    end
  end

  task :script do
    case ENV['MARKET_TOWN']
    when 'brochure'
      system 'go test -v', chdir: "#{ENV['GOPATH']}/src/brochure" or throw 'Tests failed'
    when 'checkout'
      Bundler.with_clean_env do
        set_gemfile_based_on_rake_task
        system("bundle exec rake #{ENV['RAKE_TASK']}", chdir: 'checkout') or throw 'Tests failed'
      end
    end
  end
end
