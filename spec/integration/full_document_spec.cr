require "./spec_helper"

# Full document round-trip: convert a realistic, README-shaped Markdown
# file and assert the resulting AsciiDoc contains the expected markers
# for every top-level construct (headings, lists, fenced code, table,
# quote, thematic break, link). The unit specs already cover each
# element separately; this spec makes sure the mix doesn't lose any.
describe "Integration · full README-shaped document" do
  it "produces AsciiDoc containing the expected structural markers" do
    adoc = IntegrationHelper.convert(IntegrationHelper.fixture("readme.md"))

    # Document title (level-1 heading)
    adoc.should contain("= my-library\n")

    # Level-2 sections
    adoc.should contain("== Installation")
    adoc.should contain("== Usage")
    adoc.should contain("== Features")
    adoc.should contain("== Links")

    # Inline bold / italic converted to AsciiDoc markers
    adoc.should contain("*small*")
    adoc.should contain("_things_")

    # Two fenced code blocks — one with a language, one without.
    adoc.should contain("[source,yaml]")
    adoc.should contain("[source,crystal]")
    # Unlabeled fence still wraps in `----`
    adoc.should contain("----")

    # Bullet list items converted to `* `
    adoc.should contain("* Zero dependencies")
    adoc.should contain("* Pure Crystal")
    adoc.should contain("* MIT licensed")

    # Links converted to `link:url[text]`
    adoc.should contain("link:https://example.com/docs[Documentation]")
    adoc.should contain("link:https://example.com/issues[Issue tracker]")

    # Block quote
    adoc.should contain("____")

    # Thematic break
    adoc.should contain("'''")

    # No surviving Markdown markers (regression guard)
    adoc.should_not contain("# Installation")
    adoc.should_not contain("## Usage")
    adoc.should_not contain("```yaml")
    adoc.should_not contain("```crystal")
    adoc.should_not contain("**small**")
  end

  it "produces a file on disk via convert_file" do
    out_path = IntegrationHelper.convert_to_tempfile(
      IntegrationHelper.fixture("readme.md")
    )
    begin
      File.exists?(out_path).should be_true
      content = File.read(out_path)
      content.should contain("= my-library")
      content.should contain("== Installation")
    ensure
      File.delete(out_path) if File.exists?(out_path)
    end
  end
end
