require "./kramdown_asciidoc/parser"
require "./kramdown_asciidoc/converter"

# KramdownAsciidoc converts Markdown (CommonMark subset) to AsciiDoc format.
#
# ```
# asciidoc = KramdownAsciidoc.convert("# Hello\n\nThis is **bold**.")
# # => "= Hello\n\nThis is *bold*."
# ```
module KramdownAsciidoc
  # Lue au compile-time depuis `shard.yml` via le macro `read_file`.
  # Cf. note mémoire `feedback_shard_version_macro.md` (mémoire ALOLI).
  VERSION = {{
              (read_file("#{__DIR__}/../shard.yml")
                .lines
                .find(&.starts_with?("version:")) || "version: 0.0.0")
                .gsub(/^version:\s*/, "")
                .chomp
            }}

  # Version de la gem Ruby kramdown-asciidoc utilisée comme référence.
  UPSTREAM_VERSION = "2.1.1"

  # Converts a Markdown string to AsciiDoc.
  def self.convert(markdown : String) : String
    document = Parser.parse(markdown)
    Converter.convert(document)
  end

  # Converts a Markdown file to an AsciiDoc file.
  #
  # If *output_path* is `nil`, returns the converted string.
  def self.convert_file(input_path : String, output_path : String? = nil) : String
    markdown = File.read(input_path)
    result = convert(markdown)
    if output_path
      File.write(output_path, result)
    end
    result
  end
end
