require "./kramdown_asciidoc/parser"
require "./kramdown_asciidoc/converter"

# KramdownAsciidoc converts Markdown (CommonMark subset) to AsciiDoc format.
#
# ```
# asciidoc = KramdownAsciidoc.convert("# Hello\n\nThis is **bold**.")
# # => "= Hello\n\nThis is *bold*."
# ```
module KramdownAsciidoc
  VERSION = "2.1.1"

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
