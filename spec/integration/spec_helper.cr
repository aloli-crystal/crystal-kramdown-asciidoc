require "spec"
require "../../src/kramdown_asciidoc"

# Integration-test helpers: drive `KramdownAsciidoc` end-to-end against
# realistic Markdown documents loaded from disk and assert on the shape
# of the AsciiDoc output.
#
# Unit specs (`spec/kramdown_asciidoc_spec.cr`) cover every construct
# in isolation. These integration specs complement them by round-tripping
# a full README-shaped document through `KramdownAsciidoc.convert_file`
# and by checking document-level properties (paragraph separation,
# trailing newline, no stray Markdown markers surviving).
module IntegrationHelper
  # Converts the inline Markdown source to AsciiDoc.
  def self.convert(markdown : String) : String
    KramdownAsciidoc.convert(markdown)
  end

  # Reads a fixture from `spec/integration/fixtures/` and returns its
  # content as a string.
  def self.fixture(name : String) : String
    File.read(File.join(__DIR__, "fixtures", name))
  end

  # Convenience: write `source` to a temp file, run `convert_file`, and
  # return the path of the generated `.adoc` file. The caller is
  # responsible for cleanup.
  def self.convert_to_tempfile(source : String) : String
    stem = File.tempname("kad-it")
    in_path = stem + ".md"
    out_path = stem + ".adoc"
    File.write(in_path, source)
    KramdownAsciidoc.convert_file(in_path, out_path)
    File.delete(in_path) if File.exists?(in_path)
    out_path
  end
end
