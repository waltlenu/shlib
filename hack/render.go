// render.go - Render Go templates with optional input values.
//
// A standalone CLI tool that takes a Go template file (.gotmpl),
// optionally applies input values from a JSON file and/or key=value
// arguments, and writes the rendered output to a file or stdout.
//
// Usage:
//
//	go run ./hack/render.go -t <template> -o <output> [options] [key=value ...]
//
// See -h for full help.
package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"text/template"
)

// ---------------------------------------------------------------------
// ANSI color constants
// ---------------------------------------------------------------------

const (
	colorReset  = "\033[0m"
	colorRed    = "\033[31m"
	colorGreen  = "\033[32m"
	colorYellow = "\033[33m"
	colorCyan   = "\033[36m"
	colorBold   = "\033[1m"
)

// ---------------------------------------------------------------------
// config holds parsed CLI arguments.
// ---------------------------------------------------------------------

type config struct {
	templatePath string   // path to the .gotmpl file
	outputPath   string   // output file path, or "-" for stdout
	valuesPath   string   // optional path to JSON values file
	kvPairs      []string // positional key=value arguments
	noColor      bool     // disable colorized output
}

// ---------------------------------------------------------------------
// Color and output helpers
//
// All status messages go to stderr so that stdout is reserved
// exclusively for rendered template content (when using -o -).
// ---------------------------------------------------------------------

// useColor reports whether colorized output should be used.
// It respects the NO_COLOR env var (https://no-color.org), the
// -no-color flag, and whether stderr is a terminal.
func useColor(noColorFlag bool) bool {
	if noColorFlag {
		return false
	}
	if _, ok := os.LookupEnv("NO_COLOR"); ok {
		return false
	}
	info, err := os.Stderr.Stat()
	if err != nil {
		return false
	}
	return info.Mode()&os.ModeCharDevice != 0
}

// colorize wraps msg in the given ANSI color code if color is enabled.
func colorize(color, msg string, enabled bool) string {
	if !enabled {
		return msg
	}
	return color + msg + colorReset
}

// printInfo prints a green status message to stderr.
func printInfo(msg string, color bool) {
	prefix := colorize(colorGreen, "[ok]", color)
	fmt.Fprintf(os.Stderr, "%s %s\n", prefix, msg)
}

// printWarn prints a yellow warning message to stderr.
func printWarn(msg string, color bool) {
	prefix := colorize(colorYellow, "[warn]", color)
	fmt.Fprintf(os.Stderr, "%s %s\n", prefix, msg)
}

// printError prints a red error message to stderr.
func printError(msg string, color bool) {
	prefix := colorize(colorRed, "[error]", color)
	fmt.Fprintf(os.Stderr, "%s %s\n", prefix, msg)
}

// ---------------------------------------------------------------------
// Template helper functions
//
// These are registered in every template via FuncMap so they can be
// used in pipelines, e.g. {{ .name | upper }}.
// ---------------------------------------------------------------------

// templateFuncs returns the custom function map for templates.
// data is passed through so that included files are rendered as
// templates with the same values and helpers.
func templateFuncs(data map[string]any) template.FuncMap {
	var funcs template.FuncMap
	funcs = template.FuncMap{
		// upper converts a string to uppercase.
		"upper": strings.ToUpper,

		// lower converts a string to lowercase.
		"lower": strings.ToLower,

		// title converts a string to title case.
		"title": strings.ToTitle,

		// trim removes leading and trailing whitespace.
		"trim": strings.TrimSpace,

		// default returns the value if non-empty, otherwise the fallback.
		// Usage: {{ .version | default "dev" }}
		"default": func(fallback string, val any) any {
			if val == nil {
				return fallback
			}
			if s, ok := val.(string); ok && s == "" {
				return fallback
			}
			return val
		},

		// env reads an environment variable.
		// Usage: {{ env "HOME" }}
		"env": os.Getenv,

		// include reads a file, renders it as a Go template with the
		// same function map and data, and returns the result as a string.
		// Paths are relative to the working directory.
		// Usage: {{ include "src/header.bash" }}
		"include": func(path string) (string, error) {
			raw, err := os.ReadFile(path)
			if err != nil {
				return "", fmt.Errorf("include %q: %w", path, err)
			}
			tmpl, err := template.New(filepath.Base(path)).
				Funcs(funcs).
				Option("missingkey=zero").
				Parse(string(raw))
			if err != nil {
				return "", fmt.Errorf("include %q: %w", path, err)
			}
			var buf bytes.Buffer
			if err := tmpl.Execute(&buf, data); err != nil {
				return "", fmt.Errorf("include %q: %w", path, err)
			}
			return buf.String(), nil
		},

		// glob returns a sorted list of file paths matching a pattern.
		// Uses filepath.Glob syntax. Returns an empty slice (not error)
		// when nothing matches.
		// Usage: {{ range glob "src/*/*.bash" }}{{ include . }}{{ end }}
		"glob": func(pattern string) ([]string, error) {
			matches, err := filepath.Glob(pattern)
			if err != nil {
				return nil, fmt.Errorf("glob %q: %w", pattern, err)
			}
			sort.Strings(matches)
			return matches, nil
		},

		// dirs returns the sorted unique parent directories of files
		// matching a glob pattern. Only directories that contain at
		// least one matching file are returned.
		// Usage: {{ range dirs "src/*/*.bash" }}...{{ end }}
		"dirs": func(pattern string) ([]string, error) {
			matches, err := filepath.Glob(pattern)
			if err != nil {
				return nil, fmt.Errorf("dirs %q: %w", pattern, err)
			}
			seen := make(map[string]bool)
			var result []string
			for _, m := range matches {
				dir := filepath.Dir(m)
				if !seen[dir] {
					seen[dir] = true
					result = append(result, dir)
				}
			}
			sort.Strings(result)
			return result, nil
		},

		// basename returns the last element of a path.
		// Usage: {{ basename "src/arrays" }} → "arrays"
		"basename": filepath.Base,

		// shdoc parses structured comments from a bash file and returns
		// troff-formatted man page content for all documented functions.
		// Usage: {{ shdoc "src/arrays/push.bash" }}
		"shdoc": shdocTroff,

		// replace performs string substitution.
		// Usage: {{ replace "foo.bash" ".bash" ".man" }}
		"replace": strings.ReplaceAll,

		// exists reports whether a file exists.
		// Usage: {{ if exists "src/arrays/push.man" }}...{{ end }}
		"exists": func(path string) bool {
			_, err := os.Stat(path)
			return err == nil
		},
	}
	return funcs
}

// ---------------------------------------------------------------------
// shdoc: extract structured comments from bash files and emit troff
//
// Parses comment blocks with @description, @arg, @stdout, @stderr,
// @exitcode, and @example tags above function definitions, then
// formats each function as a man page subsection.
// ---------------------------------------------------------------------

// funcDoc holds the parsed documentation for a single shell function.
type funcDoc struct {
	name        string   // function name (e.g. "shlib::version")
	description string   // @description text
	args        []string // @arg lines (e.g. "$1 string The command name")
	stdout      string   // @stdout text
	stderr      string   // @stderr text
	exitcodes   []string // @exitcode lines (e.g. "0 Success")
	examples    []string // @example lines (raw code lines)
}

// parseShdoc reads a bash file and extracts funcDoc entries from
// structured comment blocks immediately preceding function definitions.
func parseShdoc(path string) ([]funcDoc, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, fmt.Errorf("shdoc %q: %w", path, err)
	}
	defer f.Close()

	var docs []funcDoc
	var current funcDoc
	inComment := false
	inExample := false

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()
		trimmed := strings.TrimSpace(line)

		// Check for function definition — captures the preceding comment block.
		// Matches patterns like: shlib::name() { or function shlib::name() {
		if (strings.Contains(trimmed, "()") || strings.HasPrefix(trimmed, "function ")) && current.description != "" {
			// Extract function name.
			name := trimmed
			name = strings.TrimPrefix(name, "function ")
			if idx := strings.Index(name, "("); idx >= 0 {
				name = name[:idx]
			}
			name = strings.TrimSpace(name)
			current.name = name
			docs = append(docs, current)
			current = funcDoc{}
			inComment = false
			inExample = false
			continue
		}

		// Parse comment lines.
		if strings.HasPrefix(trimmed, "#") {
			// Strip the leading "# " or "#" prefix.
			content := strings.TrimPrefix(trimmed, "# ")
			if content == "#" || content == trimmed {
				content = strings.TrimPrefix(trimmed, "#")
			}

			switch {
			case strings.HasPrefix(content, "@description "):
				inComment = true
				inExample = false
				current.description = strings.TrimPrefix(content, "@description ")

			case strings.HasPrefix(content, "@arg "):
				inExample = false
				current.args = append(current.args, strings.TrimPrefix(content, "@arg "))

			case strings.HasPrefix(content, "@stdout "):
				inExample = false
				current.stdout = strings.TrimPrefix(content, "@stdout ")

			case strings.HasPrefix(content, "@stderr "):
				inExample = false
				current.stderr = strings.TrimPrefix(content, "@stderr ")

			case strings.HasPrefix(content, "@exitcode "):
				inExample = false
				current.exitcodes = append(current.exitcodes, strings.TrimPrefix(content, "@exitcode "))

			case strings.HasPrefix(content, "@example"):
				inExample = true

			case inExample:
				// Example lines are indented code following @example.
				current.examples = append(current.examples, strings.TrimPrefix(content, "  "))

			default:
				// Non-tag comment lines — ignore (or could append to description).
			}
			continue
		}

		// Non-comment, non-function line — reset if we were tracking.
		if inComment && trimmed != "" {
			current = funcDoc{}
			inComment = false
			inExample = false
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("shdoc %q: %w", path, err)
	}

	return docs, nil
}

// shdocTroff parses a bash file and returns troff-formatted man page
// content for all documented functions found in it.
func shdocTroff(path string) (string, error) {
	docs, err := parseShdoc(path)
	if err != nil {
		return "", err
	}

	var buf bytes.Buffer
	for _, d := range docs {
		// Function name as subsection header.
		fmt.Fprintf(&buf, ".SS %s\n", d.name)

		// Calling convention: bold name, italic arguments.
		// e.g. .BI "shlib::cmd_exists " "command"
		if len(d.args) > 0 {
			// Build: "name " "arg1" " " "arg2" ...
			fmt.Fprintf(&buf, ".BI \"%s \"", d.name)
			for i, arg := range d.args {
				parts := strings.SplitN(arg, " ", 3)
				// Use the type as the displayed argument name,
				// or the positional ($1, $@) if type is not descriptive.
				argName := parts[0]
				if len(parts) >= 3 {
					argName = parts[1]
				}
				if i > 0 {
					fmt.Fprintf(&buf, " \" \" \"%s\"", argName)
				} else {
					fmt.Fprintf(&buf, " \"%s\"", argName)
				}
			}
			buf.WriteString("\n")
		}

		// Description.
		buf.WriteString(".PP\n")
		fmt.Fprintf(&buf, "%s\n", d.description)

		// Arguments — detailed list.
		if len(d.args) > 0 {
			buf.WriteString(".PP\n\\fBArguments:\\fR\n")
			for _, arg := range d.args {
				// Parse "$1 string Description" into parts.
				parts := strings.SplitN(arg, " ", 3)
				if len(parts) >= 3 {
					fmt.Fprintf(&buf, ".TP\n\\fI%s\\fR (%s)\n%s\n", parts[0], parts[1], parts[2])
				} else {
					fmt.Fprintf(&buf, ".TP\n%s\n", arg)
				}
			}
		}

		// Stdout.
		if d.stdout != "" {
			fmt.Fprintf(&buf, ".PP\n\\fBStdout:\\fR %s\n", d.stdout)
		}

		// Stderr.
		if d.stderr != "" {
			fmt.Fprintf(&buf, ".PP\n\\fBStderr:\\fR %s\n", d.stderr)
		}

		// Exit codes — use .TP tagged list for clean formatting.
		if len(d.exitcodes) > 0 {
			buf.WriteString(".PP\n\\fBExit codes:\\fR\n")
			for _, ec := range d.exitcodes {
				// Parse "0 Description" into code + text.
				parts := strings.SplitN(ec, " ", 2)
				if len(parts) == 2 {
					fmt.Fprintf(&buf, ".TP\n\\fB%s\\fR\n%s\n", parts[0], parts[1])
				} else {
					fmt.Fprintf(&buf, ".TP\n%s\n", ec)
				}
			}
		}

		// Examples — use indented no-fill block.
		if len(d.examples) > 0 {
			buf.WriteString(".PP\n\\fBExample:\\fR\n.RS\n.nf\n")
			for _, ex := range d.examples {
				fmt.Fprintf(&buf, "%s\n", ex)
			}
			buf.WriteString(".fi\n.RE\n")
		}
	}

	return buf.String(), nil
}

// ---------------------------------------------------------------------
// Core functions
// ---------------------------------------------------------------------

// parseKVPairs parses a slice of "key=value" strings into a map.
// Values are split on the first "=" only, so "a=b=c" yields key "a"
// with value "b=c". Returns an error if any argument has no "=".
func parseKVPairs(args []string) (map[string]any, error) {
	m := make(map[string]any, len(args))
	for _, arg := range args {
		idx := strings.Index(arg, "=")
		if idx < 1 {
			return nil, fmt.Errorf("invalid argument (expected key=value): %q", arg)
		}
		key := arg[:idx]
		val := arg[idx+1:]
		m[key] = val
	}
	return m, nil
}

// loadValues builds the template data map by loading an optional JSON
// file and merging in key=value overrides. Key=value pairs take
// precedence over JSON keys.
func loadValues(jsonPath string, kvPairs []string) (map[string]any, error) {
	data := make(map[string]any)

	// Load JSON values file if provided.
	if jsonPath != "" {
		raw, err := os.ReadFile(jsonPath)
		if err != nil {
			return nil, fmt.Errorf("reading values file %q: %w", jsonPath, err)
		}
		if err := json.Unmarshal(raw, &data); err != nil {
			return nil, fmt.Errorf("invalid JSON in %q: %w", jsonPath, err)
		}
	}

	// Apply key=value overrides.
	kv, err := parseKVPairs(kvPairs)
	if err != nil {
		return nil, err
	}
	for k, v := range kv {
		data[k] = v
	}

	return data, nil
}

// renderTemplate parses and executes the template at tmplPath with the
// given data. It returns the rendered bytes. Rendering happens into a
// buffer so that no partial output is produced on error.
func renderTemplate(tmplPath string, data map[string]any) ([]byte, error) {
	raw, err := os.ReadFile(tmplPath)
	if err != nil {
		return nil, fmt.Errorf("reading template %q: %w", tmplPath, err)
	}

	// Use the file's base name as the template name for clearer errors.
	name := filepath.Base(tmplPath)
	tmpl, err := template.New(name).
		Funcs(templateFuncs(data)).
		Option("missingkey=zero").
		Parse(string(raw))
	if err != nil {
		return nil, fmt.Errorf("parsing template: %w", err)
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, data); err != nil {
		return nil, fmt.Errorf("rendering template: %w", err)
	}

	return buf.Bytes(), nil
}

// writeOutput writes content to the given path, or to stdout if path
// is "-".
func writeOutput(path string, content []byte) error {
	if path == "-" {
		_, err := os.Stdout.Write(content)
		return err
	}
	return os.WriteFile(path, content, 0644)
}

// ---------------------------------------------------------------------
// CLI entry points
// ---------------------------------------------------------------------

// usage prints the help message to stderr.
func usage(color bool) {
	title := colorize(colorBold, "render", color)
	cyan := func(s string) string { return colorize(colorCyan, s, color) }
	bold := func(s string) string { return colorize(colorBold, s, color) }

	fmt.Fprintf(os.Stderr, `%s - Render Go templates with optional input values

%s
  go run ./hack/render.go -t <template> -o <output> [options] [key=value ...]

%s
  %s  Path to Go template file (.gotmpl)
  %s  Output file path, or "-" for stdout

%s
  %s  Path to JSON values file
  %s      Disable colorized output
  %s      Show this help message

%s
  Values from key=value arguments override values loaded from the JSON
  file. Key=value arguments are always treated as strings. JSON values
  can be any type (strings, numbers, booleans, arrays, objects).

%s
  go run ./hack/render.go -t tmpl/readme.gotmpl -o README.md
  go run ./hack/render.go -t tmpl/readme.gotmpl -o - name=shlib version=1.0
  go run ./hack/render.go -t tmpl/readme.gotmpl -o out.md -f values.json name=override

%s
  upper, lower, title, trim, default, env,
  include, glob, dirs, basename, shdoc,
  replace, exists
`,
		title,
		bold("Usage:"),
		bold("Required:"),
		cyan("-t, -template"), cyan("-o, -output   "),
		bold("Options:"),
		cyan("-f, -values   "), cyan("-no-color"), cyan("-h, -help"),
		bold("Notes:"),
		bold("Examples:"),
		bold("Template functions:"),
	)
}

// parseArgs parses command-line flags and positional arguments.
func parseArgs() *config {
	cfg := &config{}

	// Register flags with short and long forms.
	flag.StringVar(&cfg.templatePath, "template", "", "")
	flag.StringVar(&cfg.templatePath, "t", "", "")
	flag.StringVar(&cfg.outputPath, "output", "", "")
	flag.StringVar(&cfg.outputPath, "o", "", "")
	flag.StringVar(&cfg.valuesPath, "values", "", "")
	flag.StringVar(&cfg.valuesPath, "f", "", "")
	flag.BoolVar(&cfg.noColor, "no-color", false, "")

	// Override the default usage to show our custom help.
	flag.Usage = func() {
		usage(useColor(cfg.noColor))
	}

	flag.Parse()

	// Remaining positional args are key=value pairs.
	cfg.kvPairs = flag.Args()

	return cfg
}

// run is the main logic, separated from main() so it can return an
// error instead of calling os.Exit directly. This makes it testable.
func run() error {
	cfg := parseArgs()
	color := useColor(cfg.noColor)

	// Show help if requested (flag package handles -h automatically,
	// but we also handle the case where no args are given).
	if cfg.templatePath == "" || cfg.outputPath == "" {
		if cfg.templatePath == "" && cfg.outputPath == "" && len(cfg.kvPairs) == 0 && cfg.valuesPath == "" {
			// No args at all — show help.
			usage(color)
			return nil
		}
		if cfg.templatePath == "" {
			return fmt.Errorf("-t/--template is required")
		}
		return fmt.Errorf("-o/--output is required")
	}

	// Step 1: Load values from JSON file and/or key=value args.
	data, err := loadValues(cfg.valuesPath, cfg.kvPairs)
	if err != nil {
		return err
	}

	if cfg.valuesPath != "" {
		printInfo(fmt.Sprintf("Loaded values from %s", cfg.valuesPath), color)
	}
	if len(cfg.kvPairs) > 0 {
		printInfo(fmt.Sprintf("Applied %d key=value override(s)", len(cfg.kvPairs)), color)
	}

	// Step 2: Parse and render the template.
	content, err := renderTemplate(cfg.templatePath, data)
	if err != nil {
		return err
	}

	printInfo(fmt.Sprintf("Rendered template %s", cfg.templatePath), color)

	// Step 3: Write the output.
	if err := writeOutput(cfg.outputPath, content); err != nil {
		return fmt.Errorf("writing output to %q: %w", cfg.outputPath, err)
	}

	if cfg.outputPath != "-" {
		printInfo(fmt.Sprintf("Wrote output to %s", cfg.outputPath), color)
	}

	return nil
}

func main() {
	if err := run(); err != nil {
		color := useColor(false)
		printError(err.Error(), color)
		os.Exit(1)
	}
}
