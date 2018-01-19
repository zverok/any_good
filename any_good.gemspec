Gem::Specification.new do |s|
  s.name     = 'any_good'
  s.version  = '0.0.2'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/zverok/any_good'

  s.summary = 'Is that gem any good?'
  s.licenses = ['MIT']

  s.required_ruby_version = '>= 2.3.0'

  s.files = `git ls-files exe lib LICENSE.txt README.md`.split($RS)
  s.require_paths = ["lib"]
  s.bindir = 'exe'
  s.executables << 'any_good'

  s.add_runtime_dependency 'pastel'
  s.add_runtime_dependency 'octokit'
  s.add_runtime_dependency 'gems'
  s.add_runtime_dependency 'time_math2'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubygems-tasks'
end
