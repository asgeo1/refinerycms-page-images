Gem::Specification.new do |s|
  s.name              = %q{refinerycms-page-resources}
  s.version           = %q{3.0.0.dev}
  s.description       = %q{Attach resources to pages ins Refinery CMS}
  s.summary           = %q{Page Resources extension for Refinery CMS}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://github.com/refinery/refinerycms-page-resources}
  s.authors           = ['Philip Arndt', 'David Jones']
  s.require_paths     = %w(lib)
  s.license            = %q{MIT}

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency    'refinerycms-pages', '~> 3.0.0'
  s.add_dependency    'decorators',        '~> 1.0.0'
end
