package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// writeTestFile creates a file in dir with the given name and content,
// returning its full path. It calls t.Fatal on error.
func writeTestFile(t *testing.T, dir, name, content string) string {
	t.Helper()
	path := filepath.Join(dir, name)
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		t.Fatalf("writing test file %s: %v", name, err)
	}
	return path
}

// --- parseKVPairs tests ---

func TestParseKVPairsBasic(t *testing.T) {
	m, err := parseKVPairs([]string{"name=shlib", "version=1.0"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if m["name"] != "shlib" {
		t.Errorf("name = %q, want %q", m["name"], "shlib")
	}
	if m["version"] != "1.0" {
		t.Errorf("version = %q, want %q", m["version"], "1.0")
	}
}

func TestParseKVPairsValueWithEquals(t *testing.T) {
	// Value contains "=" — split on first only.
	m, err := parseKVPairs([]string{"expr=a=b=c"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if m["expr"] != "a=b=c" {
		t.Errorf("expr = %q, want %q", m["expr"], "a=b=c")
	}
}

func TestParseKVPairsEmptyValue(t *testing.T) {
	m, err := parseKVPairs([]string{"key="})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if m["key"] != "" {
		t.Errorf("key = %q, want empty string", m["key"])
	}
}

func TestParseKVPairsMissingEquals(t *testing.T) {
	_, err := parseKVPairs([]string{"noequals"})
	if err == nil {
		t.Fatal("expected error for missing =, got nil")
	}
}

func TestParseKVPairsEmptyKey(t *testing.T) {
	_, err := parseKVPairs([]string{"=value"})
	if err == nil {
		t.Fatal("expected error for empty key, got nil")
	}
}

// --- loadValues tests ---

func TestLoadValuesFromJSON(t *testing.T) {
	dir := t.TempDir()
	vals := map[string]any{
		"name":    "shlib",
		"version": 1.0,
		"nested":  map[string]any{"key": "val"},
	}
	raw, _ := json.Marshal(vals)
	jsonPath := writeTestFile(t, dir, "values.json", string(raw))

	data, err := loadValues(jsonPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if data["name"] != "shlib" {
		t.Errorf("name = %v, want %q", data["name"], "shlib")
	}
	// JSON numbers unmarshal as float64.
	if data["version"] != 1.0 {
		t.Errorf("version = %v, want 1.0", data["version"])
	}
	nested, ok := data["nested"].(map[string]any)
	if !ok {
		t.Fatalf("nested is not a map: %T", data["nested"])
	}
	if nested["key"] != "val" {
		t.Errorf("nested.key = %v, want %q", nested["key"], "val")
	}
}

func TestLoadValuesKVPairsOnly(t *testing.T) {
	data, err := loadValues("", []string{"a=1", "b=two"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if data["a"] != "1" {
		t.Errorf("a = %v, want %q", data["a"], "1")
	}
	if data["b"] != "two" {
		t.Errorf("b = %v, want %q", data["b"], "two")
	}
}

func TestLoadValuesJSONWithOverrides(t *testing.T) {
	dir := t.TempDir()
	raw, _ := json.Marshal(map[string]string{"name": "original", "keep": "yes"})
	jsonPath := writeTestFile(t, dir, "values.json", string(raw))

	data, err := loadValues(jsonPath, []string{"name=override"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	// KV override should win.
	if data["name"] != "override" {
		t.Errorf("name = %v, want %q", data["name"], "override")
	}
	// Non-overridden key should remain.
	if data["keep"] != "yes" {
		t.Errorf("keep = %v, want %q", data["keep"], "yes")
	}
}

func TestLoadValuesInvalidJSON(t *testing.T) {
	dir := t.TempDir()
	jsonPath := writeTestFile(t, dir, "bad.json", "{not json")

	_, err := loadValues(jsonPath, nil)
	if err == nil {
		t.Fatal("expected error for invalid JSON, got nil")
	}
	if !strings.Contains(err.Error(), "invalid JSON") {
		t.Errorf("error = %q, want it to mention 'invalid JSON'", err)
	}
}

func TestLoadValuesNoInputs(t *testing.T) {
	data, err := loadValues("", nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(data) != 0 {
		t.Errorf("expected empty map, got %v", data)
	}
}

// --- renderTemplate tests ---

func TestRenderTemplateSimple(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", "Hello, {{ .name }}!")

	out, err := renderTemplate(tmplPath, map[string]any{"name": "world"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "Hello, world!" {
		t.Errorf("output = %q, want %q", string(out), "Hello, world!")
	}
}

func TestRenderTemplateWithFuncsUpper(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", "{{ .name | upper }}")

	out, err := renderTemplate(tmplPath, map[string]any{"name": "hello"})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "HELLO" {
		t.Errorf("output = %q, want %q", string(out), "HELLO")
	}
}

func TestRenderTemplateWithFuncsDefault(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", `{{ .version | default "dev" }}`)

	// Missing key — should use the default.
	out, err := renderTemplate(tmplPath, map[string]any{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "dev" {
		t.Errorf("output = %q, want %q", string(out), "dev")
	}
}

func TestRenderTemplateWithFuncsEnv(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", `{{ env "HOME" }}`)

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	// HOME should be non-empty on macOS/Linux.
	if len(out) == 0 {
		t.Error("expected non-empty output from env HOME")
	}
}

func TestRenderTemplateMissingKey(t *testing.T) {
	dir := t.TempDir()
	// Missing map keys produce <no value> — use the default func to
	// handle this gracefully in templates.
	tmplPath := writeTestFile(t, dir, "test.gotmpl", `value={{ .missing | default "" }}`)

	out, err := renderTemplate(tmplPath, map[string]any{})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "value=" {
		t.Errorf("output = %q, want %q", string(out), "value=")
	}
}

func TestRenderTemplateNoPlaceholders(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", "plain text, no placeholders")

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "plain text, no placeholders" {
		t.Errorf("output = %q, want passthrough", string(out))
	}
}

func TestRenderTemplateParseError(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "bad.gotmpl", "{{ .unclosed }")

	_, err := renderTemplate(tmplPath, nil)
	if err == nil {
		t.Fatal("expected parse error, got nil")
	}
}

// --- writeOutput tests ---

func TestWriteOutputToFile(t *testing.T) {
	dir := t.TempDir()
	outPath := filepath.Join(dir, "output.txt")
	content := []byte("rendered content here")

	if err := writeOutput(outPath, content); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	got, err := os.ReadFile(outPath)
	if err != nil {
		t.Fatalf("reading output file: %v", err)
	}
	if string(got) != string(content) {
		t.Errorf("file content = %q, want %q", string(got), string(content))
	}
}

// --- include function tests ---

func TestIncludeFunc(t *testing.T) {
	dir := t.TempDir()
	incPath := writeTestFile(t, dir, "fragment.txt", "hello from fragment")
	tmplPath := writeTestFile(t, dir, "test.gotmpl", fmt.Sprintf(`{{ include %q }}`, incPath))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "hello from fragment" {
		t.Errorf("output = %q, want %q", string(out), "hello from fragment")
	}
}

func TestIncludeFuncNotFound(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", `{{ include "/no/such/file.txt" }}`)

	_, err := renderTemplate(tmplPath, nil)
	if err == nil {
		t.Fatal("expected error for missing include, got nil")
	}
}

// --- glob function tests ---

func TestGlobFunc(t *testing.T) {
	dir := t.TempDir()
	writeTestFile(t, dir, "a.bash", "aaa")
	writeTestFile(t, dir, "b.bash", "bbb")
	writeTestFile(t, dir, "c.txt", "ccc")

	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`{{ range glob %q }}{{ . }} {{ end }}`, filepath.Join(dir, "*.bash")))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	result := strings.TrimSpace(string(out))
	// Should contain both .bash files, sorted, but not the .txt file.
	if !strings.Contains(result, "a.bash") || !strings.Contains(result, "b.bash") {
		t.Errorf("expected both .bash files, got %q", result)
	}
	if strings.Contains(result, "c.txt") {
		t.Errorf("should not include .txt file, got %q", result)
	}
}

func TestGlobFuncNoMatches(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`[{{ range glob %q }}x{{ end }}]`, filepath.Join(dir, "*.nope")))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "[]" {
		t.Errorf("output = %q, want %q", string(out), "[]")
	}
}

// --- dirs function tests ---

func TestDirsFunc(t *testing.T) {
	dir := t.TempDir()
	// Create two subdirectories with .bash files.
	os.MkdirAll(filepath.Join(dir, "_core"), 0755)
	os.MkdirAll(filepath.Join(dir, "arrays"), 0755)
	os.MkdirAll(filepath.Join(dir, "empty"), 0755) // no .bash files
	writeTestFile(t, dir, "_core/one.bash", "one")
	writeTestFile(t, dir, "arrays/two.bash", "two")

	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`{{ range dirs %q }}{{ basename . }} {{ end }}`, filepath.Join(dir, "*/*.bash")))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	result := strings.TrimSpace(string(out))
	// _core sorts before arrays, empty is excluded.
	if result != "_core arrays" {
		t.Errorf("output = %q, want %q", result, "_core arrays")
	}
}

func TestDirsFuncSkipsEmpty(t *testing.T) {
	dir := t.TempDir()
	os.MkdirAll(filepath.Join(dir, "empty"), 0755)

	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`[{{ range dirs %q }}x{{ end }}]`, filepath.Join(dir, "*/*.bash")))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "[]" {
		t.Errorf("output = %q, want %q", string(out), "[]")
	}
}

// --- basename function tests ---

func TestBasenameFunc(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", `{{ basename "src/arrays" }}`)

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "arrays" {
		t.Errorf("output = %q, want %q", string(out), "arrays")
	}
}

// --- replace function tests ---

func TestReplaceFunc(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl", `{{ replace "foo.bash" ".bash" ".man" }}`)

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "foo.man" {
		t.Errorf("output = %q, want %q", string(out), "foo.man")
	}
}

// --- exists function tests ---

func TestExistsTrue(t *testing.T) {
	dir := t.TempDir()
	target := writeTestFile(t, dir, "exists.txt", "hi")
	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`{{ if exists %q }}yes{{ else }}no{{ end }}`, target))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "yes" {
		t.Errorf("output = %q, want %q", string(out), "yes")
	}
}

func TestExistsFalse(t *testing.T) {
	dir := t.TempDir()
	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`{{ if exists %q }}yes{{ else }}no{{ end }}`, filepath.Join(dir, "nope.txt")))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if string(out) != "no" {
		t.Errorf("output = %q, want %q", string(out), "no")
	}
}

// --- shdoc tests ---

// bashWithDocs is a sample bash file with structured comments for testing.
const bashWithDocs = `#!/usr/bin/env bash

# @description Print the library version
# @stdout The version string
# @exitcode 0 Always succeeds
# @example
#   shlib::version
shlib::version() {
    echo "${SHLIB_VERSION}"
}

# @description Check if a command exists in PATH
# @arg $1 string The command name to check
# @exitcode 0 Command exists
# @exitcode 1 Command not found
# @example
#   shlib::cmd_exists git
#   shlib::cmd_exists nonexistent || echo "missing"
shlib::cmd_exists() {
    command -v "$1" &>/dev/null
}
`

func TestParseShdocBasic(t *testing.T) {
	dir := t.TempDir()
	bashPath := writeTestFile(t, dir, "funcs.bash", bashWithDocs)

	docs, err := parseShdoc(bashPath)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(docs) != 2 {
		t.Fatalf("got %d docs, want 2", len(docs))
	}

	// First function: shlib::version
	d := docs[0]
	if d.Name != "shlib::version" {
		t.Errorf("Name = %q, want %q", d.Name, "shlib::version")
	}
	if d.Description != "Print the library version" {
		t.Errorf("Description = %q", d.Description)
	}
	if d.Stdout != "The version string" {
		t.Errorf("Stdout = %q", d.Stdout)
	}
	if len(d.Args) != 0 {
		t.Errorf("expected no args, got %d", len(d.Args))
	}
	if len(d.ExitCodes) != 1 {
		t.Fatalf("expected 1 exitcode, got %d", len(d.ExitCodes))
	}
	if d.ExitCodes[0].Code != "0" || d.ExitCodes[0].Description != "Always succeeds" {
		t.Errorf("ExitCodes[0] = %+v", d.ExitCodes[0])
	}
	if len(d.Examples) != 1 || d.Examples[0] != "shlib::version" {
		t.Errorf("Examples = %v", d.Examples)
	}

	// Second function: shlib::cmd_exists
	d = docs[1]
	if d.Name != "shlib::cmd_exists" {
		t.Errorf("Name = %q, want %q", d.Name, "shlib::cmd_exists")
	}
	if len(d.Args) != 1 {
		t.Fatalf("expected 1 arg, got %d", len(d.Args))
	}
	if got := d.Args[0]; got.Position != "$1" || got.Type != "string" || got.Description != "The command name to check" {
		t.Errorf("Args[0] = %+v", got)
	}
	if len(d.ExitCodes) != 2 {
		t.Errorf("expected 2 exitcodes, got %d", len(d.ExitCodes))
	}
	if len(d.Examples) != 2 {
		t.Errorf("expected 2 examples, got %d", len(d.Examples))
	}
}

// --- parseArgLine / parseExitCodeLine tests ---

func TestParseArgLineFull(t *testing.T) {
	got := parseArgLine("$1 string The command name")
	want := ArgDoc{Position: "$1", Type: "string", Description: "The command name"}
	if got != want {
		t.Errorf("got %+v, want %+v", got, want)
	}
}

func TestParseArgLinePartial(t *testing.T) {
	got := parseArgLine("$1 string")
	want := ArgDoc{Position: "$1", Type: "string"}
	if got != want {
		t.Errorf("got %+v, want %+v", got, want)
	}
}

func TestParseArgLineBare(t *testing.T) {
	got := parseArgLine("$@")
	want := ArgDoc{Position: "$@"}
	if got != want {
		t.Errorf("got %+v, want %+v", got, want)
	}
}

func TestParseExitCodeLineFull(t *testing.T) {
	got := parseExitCodeLine("0 Always succeeds")
	want := ExitCode{Code: "0", Description: "Always succeeds"}
	if got != want {
		t.Errorf("got %+v, want %+v", got, want)
	}
}

func TestParseExitCodeLineBare(t *testing.T) {
	got := parseExitCodeLine("127")
	want := ExitCode{Code: "127"}
	if got != want {
		t.Errorf("got %+v, want %+v", got, want)
	}
}

// TestParseShdocFunctionKeyword verifies that "function name() {" syntax
// is parsed alongside the more common "name() {" form.
func TestParseShdocFunctionKeyword(t *testing.T) {
	dir := t.TempDir()
	src := `#!/usr/bin/env bash
# @description Does a thing
function shlib::thing() {
    :
}
`
	bashPath := writeTestFile(t, dir, "f.bash", src)
	docs, err := parseShdoc(bashPath)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(docs) != 1 || docs[0].Name != "shlib::thing" {
		t.Errorf("got %+v, want one function named shlib::thing", docs)
	}
}

// TestShdocTemplateFuncReturnsData verifies that {{ shdoc }} exposes
// structured FuncDoc data to templates (not a pre-rendered string).
func TestShdocTemplateFuncReturnsData(t *testing.T) {
	dir := t.TempDir()
	bashPath := writeTestFile(t, dir, "funcs.bash", bashWithDocs)
	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`{{ range shdoc %q }}[{{ .Name }}]{{ end }}`, bashPath))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	want := "[shlib::version][shlib::cmd_exists]"
	if string(out) != want {
		t.Errorf("output = %q, want %q", string(out), want)
	}
}

// TestShdocTemplateFuncArgFields verifies that ArgDoc fields are
// accessible from templates, proving the data is fully structured.
func TestShdocTemplateFuncArgFields(t *testing.T) {
	dir := t.TempDir()
	bashPath := writeTestFile(t, dir, "funcs.bash", bashWithDocs)
	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`{{ range (index (shdoc %q) 1).Args }}{{ .Position }}/{{ .Type }}/{{ .Description }}{{ end }}`, bashPath))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	want := "$1/string/The command name to check"
	if string(out) != want {
		t.Errorf("output = %q, want %q", string(out), want)
	}
}

func TestParseShdocNoFunctions(t *testing.T) {
	dir := t.TempDir()
	bashPath := writeTestFile(t, dir, "empty.bash", "#!/usr/bin/env bash\necho hello\n")

	docs, err := parseShdoc(bashPath)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(docs) != 0 {
		t.Errorf("expected 0 docs, got %d", len(docs))
	}
}

func TestParseShdocFileNotFound(t *testing.T) {
	_, err := parseShdoc("/no/such/file.bash")
	if err == nil {
		t.Fatal("expected error for missing file, got nil")
	}
}

func TestShdocTroffOutput(t *testing.T) {
	dir := t.TempDir()
	bashPath := writeTestFile(t, dir, "funcs.bash", bashWithDocs)

	troff, err := shdocTroff(bashPath)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// Check that troff output contains expected elements.
	checks := []string{
		// Function subsection header.
		".SS shlib::version",
		// Description after .PP.
		"Print the library version",
		// Stdout line.
		"\\fBStdout:\\fR The version string",
		// Exit codes as tagged list.
		"\\fBExit codes:\\fR",
		"\\fB0\\fR",
		"Always succeeds",
		// Example in indented no-fill block.
		".RS",
		".nf",
		"shlib::version",
		".fi",
		".RE",
		// Second function with calling convention.
		".SS shlib::cmd_exists",
		".BI \"shlib::cmd_exists \"",
		// Arguments as tagged list.
		"\\fBArguments:\\fR",
		"\\fI$1\\fR (string)",
		"The command name to check",
		// Exit codes.
		"\\fB1\\fR",
		"Command not found",
	}
	for _, want := range checks {
		if !strings.Contains(troff, want) {
			t.Errorf("troff output missing %q\n\nGot:\n%s", want, troff)
		}
	}
}

func TestShdocTroffInTemplate(t *testing.T) {
	dir := t.TempDir()
	bashPath := writeTestFile(t, dir, "funcs.bash", bashWithDocs)
	tmplPath := writeTestFile(t, dir, "test.gotmpl",
		fmt.Sprintf(`{{ shdocTroff %q }}`, bashPath))

	out, err := renderTemplate(tmplPath, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(string(out), ".SS shlib::version") {
		t.Error("template output missing .SS shlib::version")
	}
}

// --- colorize tests ---

func TestColorizeEnabled(t *testing.T) {
	got := colorize(colorGreen, "ok", true)
	if !strings.Contains(got, "\033[32m") {
		t.Errorf("expected ANSI green code, got %q", got)
	}
	if !strings.Contains(got, "ok") {
		t.Errorf("expected message in output, got %q", got)
	}
}

func TestColorizeDisabled(t *testing.T) {
	got := colorize(colorGreen, "ok", false)
	if got != "ok" {
		t.Errorf("expected plain %q, got %q", "ok", got)
	}
}

// --- End-to-end test ---

func TestEndToEnd(t *testing.T) {
	dir := t.TempDir()

	// Create a template file.
	tmplContent := `Project: {{ .name }}
Version: {{ .version | default "dev" }}
Author: {{ .author | upper }}
Items:{{ range .items }}
  - {{ . }}{{ end }}
`
	tmplPath := writeTestFile(t, dir, "project.gotmpl", tmplContent)

	// Create a JSON values file.
	vals := map[string]any{
		"name":    "shlib",
		"version": "1.0",
		"author":  "walt",
		"items":   []string{"arrays", "strings", "logging"},
	}
	raw, _ := json.Marshal(vals)
	jsonPath := writeTestFile(t, dir, "values.json", string(raw))

	// Load values with an override.
	data, err := loadValues(jsonPath, []string{"version=2.0"})
	if err != nil {
		t.Fatalf("loadValues: %v", err)
	}

	// Render.
	out, err := renderTemplate(tmplPath, data)
	if err != nil {
		t.Fatalf("renderTemplate: %v", err)
	}

	// Write to file.
	outPath := filepath.Join(dir, "output.txt")
	if err := writeOutput(outPath, out); err != nil {
		t.Fatalf("writeOutput: %v", err)
	}

	// Verify.
	got, _ := os.ReadFile(outPath)
	result := string(got)

	if !strings.Contains(result, "Project: shlib") {
		t.Error("missing project name")
	}
	if !strings.Contains(result, "Version: 2.0") {
		t.Error("version override not applied")
	}
	if !strings.Contains(result, "Author: WALT") {
		t.Error("upper function not applied to author")
	}
	if !strings.Contains(result, "- arrays") {
		t.Error("missing items")
	}
}
