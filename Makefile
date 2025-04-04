# Makefile for Pandoc MLA formatting with fixed input file

# Configuration variables
INPUT_FILE := input.md
OUTPUT_FORMAT := pdf
OUTPUT_FILE := $(INPUT_FILE:.md=.$(OUTPUT_FORMAT))
BIB_FILE := references.bib
CSL_FILE := modern-language-association.csl
PANDOC_OPTS := --citeproc

# Default target
all: $(OUTPUT_FILE)

# Rule to convert input.md to output format
$(OUTPUT_FILE): $(INPUT_FILE) $(BIB_FILE) $(CSL_FILE)
	pandoc $(INPUT_FILE) $(PANDOC_OPTS) --bibliography=$(BIB_FILE) --csl=$(CSL_FILE) -o $(OUTPUT_FILE)

# Target to clean up generated files
clean:
	rm -f $(OUTPUT_FILE)

# Target to download the MLA CSL file if needed
$(CSL_FILE):
	curl -s -o $(CSL_FILE) https://raw.githubusercontent.com/citation-style-language/styles/master/modern-language-association.csl

# Target to create a template input markdown file with frontmatter
template:
	@echo "---" > $(INPUT_FILE)
	@echo "title: \"Your Paper Title\"" >> $(INPUT_FILE)
	@echo "subtitle: \"Optional Subtitle\"" >> $(INPUT_FILE)
	@echo "author: \"Your Name\"" >> $(INPUT_FILE)
	@echo "instructor: \"Professor Name\"" >> $(INPUT_FILE)
	@echo "course: \"Course Name\"" >> $(INPUT_FILE)
	@echo "date: \"$(shell date +%B\ %d,\ %Y)\"" >> $(INPUT_FILE)
	@echo "documentclass: article" >> $(INPUT_FILE)
	@echo "geometry: margin=1in" >> $(INPUT_FILE)
	@echo "fontsize: 12pt" >> $(INPUT_FILE)
	@echo "linestretch: 2" >> $(INPUT_FILE)
	@echo "header-includes:" >> $(INPUT_FILE)
	@echo "  - \\usepackage{setspace}" >> $(INPUT_FILE)
	@echo "  - \\doublespacing" >> $(INPUT_FILE)
	@echo "  - \\usepackage{fancyhdr}" >> $(INPUT_FILE)
	@echo "  - \\pagestyle{fancy}" >> $(INPUT_FILE)
	@echo "  - \\fancyhead[R]{\\thepage}" >> $(INPUT_FILE)
	@echo "  - \\fancyhead[L]{Your Last Name}" >> $(INPUT_FILE)
	@echo "  - \\fancyfoot{}" >> $(INPUT_FILE)
	@echo "---" >> $(INPUT_FILE)
	@echo "" >> $(INPUT_FILE)
	@echo "Your content starts here..." >> $(INPUT_FILE)

# Template for bibliography file
bib-template:
	@echo "@book{smith2023," > $(BIB_FILE)
	@echo "  author = {Smith, John}," >> $(BIB_FILE)
	@echo "  title = {Example Book Title}," >> $(BIB_FILE)
	@echo "  publisher = {Publisher Name}," >> $(BIB_FILE)
	@echo "  year = {2023}," >> $(BIB_FILE)
	@echo "  address = {City, State}" >> $(BIB_FILE)
	@echo "}" >> $(BIB_FILE)
	@echo "" >> $(BIB_FILE)
	@echo "@article{jones2022," >> $(BIB_FILE)
	@echo "  author = {Jones, Sarah}," >> $(BIB_FILE)
	@echo "  title = {Example Article Title}," >> $(BIB_FILE)
	@echo "  journal = {Journal Name}," >> $(BIB_FILE)
	@echo "  volume = {45}," >> $(BIB_FILE)
	@echo "  number = {2}," >> $(BIB_FILE)
	@echo "  pages = {123-145}," >> $(BIB_FILE)
	@echo "  year = {2022}" >> $(BIB_FILE)
	@echo "}" >> $(BIB_FILE)
	@echo "This [@smith2023] is a test reference" >> $(INPUT_FILE) #puts a test reference into the main markdown file

# Target to generate docx instead of pdf
docx: 
	$(eval OUTPUT_FORMAT := docx)
	$(eval OUTPUT_FILE := $(INPUT_FILE:.md=.$(OUTPUT_FORMAT)))
	pandoc $(INPUT_FILE) $(PANDOC_OPTS) --bibliography=$(BIB_FILE) --csl=$(CSL_FILE) -o $(OUTPUT_FILE)

# Help target
help:
	@echo "Pandoc MLA Formatting Makefile (Fixed Input)"
	@echo "-----------------------------------------"
	@echo "Available targets:"
	@echo "  all        - Generate output file from input.md (default)"
	@echo "  clean      - Remove generated output file"
	@echo "  template   - Create a template input.md file with MLA frontmatter"
	@echo "  bib-template - Create a template bibliography file"
	@echo "  docx       - Generate .docx file instead of PDF"
	@echo "  help       - Display this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make             - Convert input.md to PDF"
	@echo "  make docx        - Convert input.md to DOCX"
	@echo "  make clean       - Remove generated file"
	@echo "  make template    - Create template input.md"

.PHONY: all clean template bib-template docx help
