# Packages the bubastis jar so Ruby projects can depend on it instead of
# committing the binary. The jar is not in git: CI builds it with Maven and
# copies it into jars/ before `gem build`. To build locally:
#
#   mvn -B package -DskipTests -Drevision=1.4.1
#   mkdir -p jars && cp target/bubastis-1.4.1.jar jars/
#   gem build ontoportal-bubastis.gemspec
#
# The gem version is the jar version unless GEM_VERSION is set, for example
# 1.4.1.1 for a packaging-only fix to the 1.4.1 jar.
jars = Dir[File.join(__dir__, 'jars', 'bubastis-*.jar')].map { |f| File.basename(f) }
abort "expected exactly one jars/bubastis-*.jar, found #{jars.inspect}" unless jars.length == 1
jar = jars.first
jar_version = jar[/\Abubastis-(.+)\.jar\z/, 1]
# Point at the repository that built the gem: GitHub Actions sets
# GITHUB_REPOSITORY, so a fork that publishes its own release links to itself.
repo_url = "https://github.com/#{ENV.fetch('GITHUB_REPOSITORY', 'ncbo/bubastis')}"

Gem::Specification.new do |s|
  s.name        = 'ontoportal-bubastis'
  s.version     = ENV.fetch('GEM_VERSION', jar_version).sub(/-SNAPSHOT\z/, '.pre')
  s.summary     = 'The bubastis ontology diff jar, packaged for OntoPortal'
  s.description = 'Ships the bubastis command-line jar (an OWL ontology diff tool) ' \
                  'and returns its path. Needs Java 11 or later at run time.'
  s.authors     = ['OntoPortal Alliance']
  s.homepage    = repo_url
  s.license     = 'Apache-2.0'
  s.files       = ['lib/ontoportal/bubastis.rb', "jars/#{jar}", 'LICENCE', 'README.md']
  s.required_ruby_version = '>= 2.7'
  s.requirements << 'Java 11 or later'
  s.metadata = {
    'source_code_uri' => repo_url,
    'rubygems_mfa_required' => 'true'
  }
end
