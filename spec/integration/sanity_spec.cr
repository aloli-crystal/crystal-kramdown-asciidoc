require "./spec_helper"

# Baseline check: the converter runs without raising on trivial input
# and produces the minimal expected output.
describe "Integration · sanity" do
  it "converts an empty document to an empty string (or whitespace only)" do
    IntegrationHelper.convert("").strip.should eq("")
  end

  it "always ends non-empty output with a trailing newline" do
    result = IntegrationHelper.convert("Hello.")
    result.ends_with?("\n").should be_true
  end

  it "preserves author words when converting" do
    result = IntegrationHelper.convert(
      "This paragraph mentions Paris, Crystal and Markdown by name."
    )
    result.should contain("Paris")
    result.should contain("Crystal")
    result.should contain("Markdown")
  end

  it "leaves no stray Markdown strong/em markers in the output of a mixed paragraph" do
    result = IntegrationHelper.convert("A **bold** and *italic* phrase.")
    # The AsciiDoc markup uses `*bold*` and `_italic_`, so the substrings
    # `**bold**` (Markdown) and `*italic*` (Markdown italic) must NOT
    # appear — a regression would mean the parser missed the tokens.
    result.should_not contain("**bold**")
    result.should_not contain("_*italic*_") # surrounded by ALT italic
    result.should contain("*bold*")
    result.should contain("_italic_")
  end
end
