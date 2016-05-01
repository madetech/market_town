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
