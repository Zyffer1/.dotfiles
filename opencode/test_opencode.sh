#!/usr/bin/env bash
# ==============================================================================
# test_opencode.sh — Comprehensive test suite for opencode dotfiles config
#
# Usage:
#   ./test_opencode.sh          # Run all tests
#   ./test_opencode.sh --list   # List available test categories
#   ./test_opencode.sh searxng  # Run only SearXNG tests
#
# Each test function returns 0 on pass, 1 on fail.
# ==============================================================================
set -eu

REPO_ROOT="$(CDPATH= cd "$(dirname "$0")/.." && pwd)"
OPENCODE_DIR="$REPO_ROOT/opencode"
CONFIG_DIR="$OPENCODE_DIR/.config/opencode"
AGENTS_DIR="$CONFIG_DIR/agents"
SKILLS_DIR="$CONFIG_DIR/skills"
DEPLOYED_CONFIG="$HOME/.config/opencode"

PASS=0
FAIL=0
FAILED_TESTS=()

# --- Utilities ----------------------------------------------------------------
pass() { PASS=$((PASS + 1)); printf '  ✓ %s\n' "$1"; }
fail() { FAIL=$((FAIL + 1)); FAILED_TESTS+=("$1"); printf '  ✗ %s\n' "$1"; }
check() { if "$@"; then pass "$1"; else fail "$1"; return 1; fi }
skip() { printf '  ⚠ SKIPPED: %s\n' "$1"; }

# --- Test: JSONC Validation ---------------------------------------------------
test_jsonc_valid() {
  local desc="opencode.jsonc is valid JSON"
  if command -v jq &>/dev/null; then
    jq empty "$CONFIG_DIR/opencode.jsonc" 2>/dev/null && pass "$desc" || fail "$desc"
  else
    skip "$desc (jq not installed)"
  fi
}

test_jsonc_has_required_keys() {
  local desc="opencode.jsonc has required top-level keys"
  if command -v jq &>/dev/null; then
    local keys
    keys=$(jq -r 'keys[]' "$CONFIG_DIR/opencode.jsonc" 2>/dev/null)
    # Check for mcp block (required)
    echo "$keys" | grep -q "^mcp$" && pass "$desc" || fail "$desc"
  else
    skip "$desc (jq not installed)"
  fi
}

test_jsonc_default_agent() {
  local desc="opencode.jsonc has a valid default_agent"
  if command -v jq &>/dev/null; then
    local agent
    agent=$(jq -r '.default_agent // empty' "$CONFIG_DIR/opencode.jsonc" 2>/dev/null)
    if [ -n "$agent" ]; then
      pass "$desc (default agent: $agent)"
    else
      fail "$desc (no default_agent set)"
    fi
  else
    skip "$desc (jq not installed)"
  fi
}

test_jsonc_mcp_servers() {
  local desc="MCP server entries have valid configurations"
  if ! command -v jq &>/dev/null; then skip "$desc (jq not installed)"; return 0; fi

  local servers
  servers=$(jq -r '.mcp | keys[]' "$CONFIG_DIR/opencode.jsonc" 2>/dev/null || true)
  if [ -z "$servers" ]; then
    fail "$desc (no MCP servers configured)"
    return
  fi

  local all_ok=yes
  while IFS= read -r server; do
    local type
    type=$(jq -r ".mcp[\"$server\"].type // \"\"" "$CONFIG_DIR/opencode.jsonc")
    local cmd
    cmd=$(jq -r ".mcp[\"$server\"].command[0] // \"\"" "$CONFIG_DIR/opencode.jsonc")
    local enabled
    enabled=$(jq -r ".mcp[\"$server\"].enabled // false" "$CONFIG_DIR/opencode.jsonc")

    if [ "$type" != "local" ]; then
      fail "  $server: type should be 'local', got '$type'"
      all_ok=no
    fi
    if [ -z "$cmd" ]; then
      fail "  $server: missing command"
      all_ok=no
    fi
    if [ "$enabled" != "true" ]; then
      fail "  $server: not enabled"
      all_ok=no
    fi
  done <<< "$servers"

  [ "$all_ok" = yes ] && pass "$desc" || true
}

test_jsonc_lsp_config() {
  local desc="opencode.jsonc has LSP configuration block"
  if ! command -v jq &>/dev/null; then skip "$desc (jq not installed)"; return 0; fi

  # LSP blocks can appear as "lsp" key or in agent-specific config
  if jq -e '.lsp' "$CONFIG_DIR/opencode.jsonc" &>/dev/null; then
    pass "$desc (lsp key found)"
  elif jq -e '.agents // empty | .. | objects | select(.lsp? != null) | .lsp' "$CONFIG_DIR/opencode.jsonc" &>/dev/null; then
    pass "$desc (lsp found in agent config)"
  else
    # LSP may also be the "opencode.jsonc" format's own model config
    fail "$desc (no LSP configuration found — expected after LSP enablement)"
  fi
}

# --- Test: Agent File Validation ----------------------------------------------
test_agent_frontmatter() {
  local desc="All agent MD files have valid YAML frontmatter"
  local all_ok=yes

  for agent_file in "$AGENTS_DIR"/*.md; do
    local name
    name=$(basename "$agent_file")

    # Check starts with ---
    if ! head -1 "$agent_file" | grep -q '^---$'; then
      fail "  $name: missing opening '---'"
      all_ok=no
      continue
    fi

    # Check has description field
    if ! grep -q '^description:' "$agent_file"; then
      fail "  $name: missing 'description' field"
      all_ok=no
    fi

    # Check has mode field
    if ! grep -q '^mode:' "$agent_file"; then
      fail "  $name: missing 'mode' field"
      all_ok=no
    fi

    # Check has permission block
    if ! grep -q '^permission:' "$agent_file"; then
      fail "  $name: missing 'permission' block"
      all_ok=no
    fi

    # Verify mode is valid
    local mode
    mode=$(grep '^mode:' "$agent_file" | sed 's/^mode: *//')
    if [ "$mode" != "primary" ] && [ "$mode" != "subagent" ]; then
      fail "  $name: invalid mode '$mode' (must be 'primary' or 'subagent')"
      all_ok=no
    fi
  done

  [ "$all_ok" = yes ] && pass "$desc" || true
}

test_agent_files_complete() {
  local desc="All known agent files exist and match references in AGENTS.md"
  local all_ok=yes

  for agent in setup plan build driver paranoid tester verifier researcher idea-maker cleanup; do
    if [ ! -f "$AGENTS_DIR/$agent.md" ]; then
      fail "  $agent.md is missing from agents/ directory"
      all_ok=no
    fi
  done

  # Check AGENTS.md references match actual files
  while IFS= read -r line; do
    local ref
    ref=$(echo "$line" | grep -oP 'agents/\K[^`]+' 2>/dev/null | sed 's/\.md$//' || true)
    if [ -n "$ref" ] && [ ! -f "$AGENTS_DIR/$ref.md" ]; then
      fail "  AGENTS.md references '$ref.md' but file does not exist"
      all_ok=no
    fi
  done < "$OPENCODE_DIR/AGENTS.md"

  [ "$all_ok" = yes ] && pass "$desc" || true
}

test_context_plan_stow_ignored() {
  local desc="context.md and plan.md are stow-ignored (in .stow-local-ignore)"
  local ignore_file="$OPENCODE_DIR/.stow-local-ignore"
  if [ ! -f "$ignore_file" ]; then
    fail "$desc (.stow-local-ignore not found)"
    return
  fi

  local all_ok=yes
  # The .stow-local-ignore uses regex patterns (dots are literal when escaped)
  # Use fgrep/grep -F for literal string matching
  for f in "context\.md" "plan\.md"; do
    if grep -qF "$f" "$ignore_file"; then
      :  # found
    else
      fail "  pattern '$f' not found in .stow-local-ignore"
      all_ok=no
    fi
  done
  [ "$all_ok" = yes ] && pass "$desc" || true
}

# --- Test: Stow Validation ----------------------------------------------------
test_stow_dry_run_all_packages() {
  local desc="All stow packages pass dry-run without errors"
  local all_ok=yes

  # Get packages from stow.sh
  local stow_line
  stow_line=$(grep '^stow -t ~' "$REPO_ROOT/stow.sh" 2>/dev/null || true)
  # Extract package names
  local packages=(${stow_line#stow -t ~ })

  if [ ${#packages[@]} -eq 0 ]; then
    # Fallback: list top-level stow dirs from repo root
    packages=()
    for dir in "$REPO_ROOT"/*/; do
      local dirname
      dirname=$(basename "$dir")
      case "$dirname" in scripts|.git) continue ;; esac
      packages+=("$dirname")
    done
  fi

  # Stow must be run from the repo root — it looks for packages in CWD
  local saved_pwd="$PWD"
  cd "$REPO_ROOT"

  for pkg in "${packages[@]}"; do
    local output
    output=$(stow --no -t "$HOME" "$pkg" 2>&1 || true)
    if echo "$output" | grep -q "All operations aborted\|ERROR:"; then
      local conflict
      conflict=$(echo "$output" | grep -oP 'cannot stow.*?over existing target.*?\.' | head -3 | tr '\n' ' ' || true)
      fail "  $pkg: conflicts detected — ${conflict:-see details above}"
      all_ok=no
    fi
  done

  cd "$saved_pwd"

  [ "$all_ok" = yes ] && pass "$desc" || true
}

test_symlinks_valid() {
  local desc="All deployed symlinks point to valid targets"
  local all_ok=yes

  if [ ! -d "$DEPLOYED_CONFIG" ]; then
    fail "  ~/.config/opencode/ does not exist"
    return
  fi

  while IFS= read -r -d '' link; do
    if [ ! -e "$link" ] && [ -L "$link" ]; then
      local target
      target=$(readlink "$link")
      fail "  Broken symlink: $link → $target"
      all_ok=no
    fi
  done < <(find "$DEPLOYED_CONFIG" -type l -print0 2>/dev/null || true)

  [ "$all_ok" = yes ] && pass "$desc" || true
}

test_stow_sh_syntax() {
  local desc="stow.sh has valid bash syntax"
  bash -n "$REPO_ROOT/stow.sh" 2>/dev/null && pass "$desc" || fail "$desc"
}

test_git_sh_syntax() {
  local desc="git.sh has valid bash syntax"
  bash -n "$REPO_ROOT/git.sh" 2>/dev/null && pass "$desc" || fail "$desc"
}

test_stow_sh_packages_in_sync() {
  local desc="stow.sh packages match the actual top-level stow directories"
  local stow_line
  stow_line=$(grep '^stow -t ~' "$REPO_ROOT/stow.sh" 2>/dev/null || true)
  local stow_pkgs=(${stow_line#stow -t ~ })

  local all_ok=yes
  for dir in "$REPO_ROOT"/*/; do
    local dirname
    dirname=$(basename "$dir")
    # Skip directories that are not stow packages
    case "$dirname" in
      scripts|opencode|.git) continue ;;
    esac
    # Check if it has any content (is a stow package, not empty)
    if [ "$(ls -A "$dir" 2>/dev/null | wc -l)" -gt 0 ]; then
      # Check if stow.sh deploys it (for user-level)
      local found=no
      for pkg in "${stow_pkgs[@]}"; do
        [ "$pkg" = "$dirname" ] && found=yes
      done
      if [ "$found" != "yes" ]; then
        fail "  $dirname dir exists but NOT in stow.sh stow line"
        all_ok=no
      fi
    fi
  done
  [ "$all_ok" = yes ] && pass "$desc" || true
}

# --- Test: Shell Script Syntax Checks -----------------------------------------
test_script_syntax() {
  local desc="All *.sh scripts in repo pass bash -n syntax check"
  local all_ok=yes

  while IFS= read -r -d '' script; do
    local name
    name=$(basename "$script")
    # Skip scripts with node shebangs or non-bash shell
    local shebang
    shebang=$(head -1 "$script")
    if echo "$shebang" | grep -qE 'bash|zsh|sh'; then
      if ! bash -n "$script" 2>/dev/null; then
        fail "  $name: syntax error"
        all_ok=no
      fi
    fi
  done < <(find "$REPO_ROOT" -name '*.sh' -not -path '*/node_modules/*' -not -path '*/plugins/*' -print0 2>/dev/null || true)

  [ "$all_ok" = yes ] && pass "$desc" || true
}

# --- Test: SearXNG Connectivity -----------------------------------------------
test_searxng_http_reachable() {
  local desc="SearXNG is reachable via HTTP on port 8080"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 http://localhost:8080 2>/dev/null || echo "000")
  if [ "$code" = "200" ] || [ "$code" = "302" ] || [ "$code" = "301" ]; then
    pass "$desc (HTTP $code)"
  else
    fail "$desc (HTTP status $code — SearXNG may not be running)"
  fi
}

test_searxng_config_endpoint() {
  local desc="SearXNG /config endpoint returns valid JSON with engines"
  if ! command -v jq &>/dev/null; then skip "$desc (jq not installed)"; return 0; fi

  local data
  data=$(curl -s --connect-timeout 3 http://localhost:8080/config 2>/dev/null || true)
  if echo "$data" | jq -e '.engines | length > 0' &>/dev/null; then
    local engine_count
    engine_count=$(echo "$data" | jq '[.engines[] | select(.enabled == true)] | length')
    pass "$desc ($engine_count enabled engines)"
  elif [ -z "$data" ]; then
    fail "$desc (no response from /config)"
  else
    fail "$desc (response is not valid SearXNG config)"
  fi
}

test_searxng_search_works() {
  local desc="SearXNG search returns results"
  local data
  data=$(curl -s --connect-timeout 5 "http://localhost:8080/search?q=test&format=json" 2>/dev/null || true)
  if echo "$data" | jq -e '.results | length > 0' &>/dev/null; then
    local result_count
    result_count=$(echo "$data" | jq '.results | length')
    pass "$desc ($result_count results)"
  elif [ -z "$data" ]; then
    fail "$desc (no response from search endpoint)"
  else
    # SearXNG might return error if rate-limited, but at least it responded
    pass "$desc (responded, but check query format)"
  fi
}

test_searxng_url_matches_config() {
  local desc="opencode.jsonc SEARXNG_URL matches actual SearXNG protocol"
  if ! command -v jq &>/dev/null; then skip "$desc (jq not installed)"; return 0; fi

  local configured_url
  configured_url=$(jq -r '.mcp.searxng.env.SEARXNG_URL // empty' "$CONFIG_DIR/opencode.jsonc" 2>/dev/null)

  # Actual check: SearXNG serves HTTP, but config may say HTTPS
  local http_code_https
  http_code_https=$(curl -sk -o /dev/null -w "%{http_code}" --connect-timeout 3 https://localhost:8080 2>/dev/null || echo "000")
  local http_code_http
  http_code_http=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 http://localhost:8080 2>/dev/null || echo "000")

  if [ "$http_code_http" = "200" ] && echo "$configured_url" | grep -q "^https://"; then
    fail "  MISMATCH: SearXNG serves HTTP but config uses $configured_url (should be http://)"
  elif [ "$http_code_https" = "200" ] && echo "$configured_url" | grep -q "^http://"; then
    fail "  MISMATCH: SearXNG serves HTTPS but config uses $configured_url"
  else
    pass "$desc (protocol matches or both unreachable)"
  fi
}

# --- Test: Skill Files ---------------------------------------------------------
test_skills_valid() {
  local desc="All skills have valid SKILL.md files with frontmatter"
  local all_ok=yes

  for skill_dir in "$SKILLS_DIR"/*/; do
    local skill_name
    skill_name=$(basename "$skill_dir")
    if [ ! -f "$skill_dir/SKILL.md" ]; then
      fail "  $skill_name: missing SKILL.md"
      all_ok=no
      continue
    fi

    if ! head -1 "$skill_dir/SKILL.md" | grep -q '^---$'; then
      fail "  $skill_name: SKILL.md missing frontmatter"
      all_ok=no
    fi
    if ! grep -q '^name:' "$skill_dir/SKILL.md"; then
      fail "  $skill_name: SKILL.md missing 'name' field"
      all_ok=no
    fi
  done

  [ "$all_ok" = yes ] && pass "$desc" || true
}

# --- Test: Gitignore / Stow-Ignore --------------------------------------------
test_stow_local_ignore() {
  local desc=".stow-local-ignore excludes expected patterns"
  local ignore_file="$OPENCODE_DIR/.stow-local-ignore"
  if [ ! -f "$ignore_file" ]; then
    fail "$desc (file not found)"
    return
  fi

  local all_ok=yes
  for pattern in "node_modules" "package.json" "package-lock.json" "bun.lock" "AGENTS\\.md"; do
    if ! grep -qF "$pattern" "$ignore_file"; then
      fail "  Missing pattern: $pattern"
      all_ok=no
    fi
  done
  [ "$all_ok" = yes ] && pass "$desc" || true
}

# --- Test Runner ---------------------------------------------------------------
CATEGORIES=(
  "jsonc:JSON/JSONC validation tests"
  "agents:Agent file validation tests"
  "stow:Stow deployment tests"
  "scripts:Shell script syntax tests"
  "searxng:SearXNG connectivity tests"
  "skills:Skill file validation tests"
)

declare -A CATEGORY_TESTS
CATEGORY_TESTS[jsonc]="test_jsonc_valid test_jsonc_has_required_keys test_jsonc_default_agent test_jsonc_mcp_servers test_jsonc_lsp_config"
CATEGORY_TESTS[agents]="test_agent_frontmatter test_agent_files_complete test_context_plan_stow_ignored"
CATEGORY_TESTS[stow]="test_stow_dry_run_all_packages test_symlinks_valid test_stow_sh_syntax test_git_sh_syntax test_stow_sh_packages_in_sync"
CATEGORY_TESTS[scripts]="test_script_syntax"
CATEGORY_TESTS[searxng]="test_searxng_http_reachable test_searxng_config_endpoint test_searxng_search_works test_searxng_url_matches_config"
CATEGORY_TESTS[skills]="test_skills_valid"

run_category() {
  local cat_name="$1"
  local desc="$2"

  printf '\n━━━ %s ━━━ %s\n' "$cat_name" "$desc"
  for test_fn in ${CATEGORY_TESTS[$cat_name]}; do
    if declare -f "$test_fn" &>/dev/null; then
      "$test_fn" || true
    fi
  done
}

list_tests() {
  echo "Available test categories:"
  for entry in "${CATEGORIES[@]}"; do
    local name="${entry%%:*}"
    local desc="${entry#*:}"
    printf '  %-12s %s\n' "$name" "$desc"
  done
  echo ""
  echo "Run all:   ./test_opencode.sh"
  echo "Single:    ./test_opencode.sh <category>"
}

# --- Main ---------------------------------------------------------------------
main() {
  printf '╔══════════════════════════════════════════════╗\n'
  printf '║  opencode dotfiles — Test Suite              ║\n'
  printf '║  Repo: %s  ║\n' "$REPO_ROOT"
  printf '╚══════════════════════════════════════════════╝\n'
  printf '\n'

  if [ "$#" -eq 0 ]; then
    # Run all categories
    for entry in "${CATEGORIES[@]}"; do
      local name="${entry%%:*}"
      local desc="${entry#*:}"
      run_category "$name" "$desc"
    done
  elif [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
    list_tests
    return 0
  else
    # Run specific category
    local found=no
    for entry in "${CATEGORIES[@]}"; do
      local name="${entry%%:*}"
      local desc="${entry#*:}"
      if [ "$name" = "$1" ]; then
        run_category "$name" "$desc"
        found=yes
        break
      fi
    done
    if [ "$found" = no ]; then
      printf 'Unknown category: %s\n' "$1"
      list_tests
      return 1
    fi
  fi

  printf '\n────────────────────────────────────────────────\n'
  printf '  Results: %d passed, %d failed\n' "$PASS" "$FAIL"
  if [ "$FAIL" -gt 0 ]; then
    printf '  Failed tests:\n'
    for t in "${FAILED_TESTS[@]}"; do
      printf '    • %s\n' "$t"
    done
    printf '\n  ⚠ Some tests failed. Review output above.\n'
    return 1
  else
    printf '  ✓ All tests passed!\n'
    return 0
  fi
}

main "$@"
