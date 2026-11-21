module Ontoportal
  # Locates the bubastis jar shipped in this gem. Run it with
  # `java -jar #{Ontoportal::Bubastis.jar_path} -ontology1 OLD -ontology2 NEW ...`.
  # Bubastis exits 0 even when it cannot load an input, so callers should
  # treat a missing output file as the failure signal.
  module Bubastis
    JAR_DIR = File.expand_path('../../jars', __dir__)

    def self.jar_path
      jars = Dir[File.join(JAR_DIR, 'bubastis-*.jar')]
      raise LoadError, "no bubastis jar in #{JAR_DIR}" if jars.empty?

      jars.first
    end

    # Version of the jar itself, which can differ from the gem version.
    def self.jar_version
      File.basename(jar_path)[/\Abubastis-(.+)\.jar\z/, 1]
    end
  end
end
