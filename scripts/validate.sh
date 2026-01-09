#!/bin/bash
#
# inner-loop-os Validator v1.3.0
# Validates protocol structure, file integrity, and state consistency
#
# Usage: ./scripts/validate.sh [--strict] [--fix] [--json]
#
# Options:
#   --strict  Treat warnings as errors (exit 1 on any warning)
#   --fix     Attempt to fix simple issues (create missing dirs)
#   --json    Output results as JSON (for CI integration)
#
# Exit codes:
#   0 - All checks passed
#   1 - Errors found
#   2 - Script error (invalid usage, etc.)

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

VERSION="1.3.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Valid states for STATUS.md
VALID_STATES=("EXPLORING" "DEFINING" "BUILDING" "REFINING" "SHIPPING" "STALLED")

# Required protocol files
REQUIRED_FILES=(
    "DR-X-MANIFEST.md"
)

# Expected protocol files (warning if missing)
EXPECTED_FILES=(
    "README.md"
    "LICENSE"
    "system/ETHOS.md"
    "system/DECISION.md"
    "system/RETRO.md"
    "templates/GOAL.md"
    "templates/STATUS.md"
    "templates/PRD.md"
    "templates/UX.md"
)

# Control files that may exist in work/ or root
CONTROL_FILES=("GOAL.md" "STATUS.md" "PRD.md" "UX.md")

# ============================================================================
# GLOBALS
# ============================================================================

ERRORS=0
WARNINGS=0
FIXES=0
STRICT_MODE=false
FIX_MODE=false
JSON_MODE=false
RESULTS=()

# ============================================================================
# HELPERS
# ============================================================================

# Colors (disabled if not a terminal or in JSON mode)
if [[ -t 1 ]] && [[ "$JSON_MODE" != "true" ]]; then
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    RED=''
    YELLOW=''
    GREEN=''
    BLUE=''
    BOLD=''
    NC=''
fi

log_error() {
    local msg="$1"
    local file="${2:-}"
    ((ERRORS++))
    if [[ "$JSON_MODE" == "true" ]]; then
        RESULTS+=("{\"level\":\"error\",\"message\":\"$msg\",\"file\":\"$file\"}")
    else
        echo -e "${RED}✗ ERROR${NC}: $msg"
    fi
}

log_warning() {
    local msg="$1"
    local file="${2:-}"
    ((WARNINGS++))
    if [[ "$JSON_MODE" == "true" ]]; then
        RESULTS+=("{\"level\":\"warning\",\"message\":\"$msg\",\"file\":\"$file\"}")
    else
        echo -e "${YELLOW}⚠ WARNING${NC}: $msg"
    fi
}

log_success() {
    local msg="$1"
    if [[ "$JSON_MODE" == "true" ]]; then
        RESULTS+=("{\"level\":\"success\",\"message\":\"$msg\",\"file\":\"\"}")
    else
        echo -e "${GREEN}✓${NC} $msg"
    fi
}

log_info() {
    local msg="$1"
    if [[ "$JSON_MODE" != "true" ]]; then
        echo -e "${BLUE}ℹ${NC} $msg"
    fi
}

log_fix() {
    local msg="$1"
    ((FIXES++))
    if [[ "$JSON_MODE" == "true" ]]; then
        RESULTS+=("{\"level\":\"fix\",\"message\":\"$msg\",\"file\":\"\"}")
    else
        echo -e "${GREEN}⚡ FIXED${NC}: $msg"
    fi
}

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

check_required_files() {
    log_info "Checking required files..."
    
    for file in "${REQUIRED_FILES[@]}"; do
        if [[ -f "$ROOT_DIR/$file" ]]; then
            log_success "$file exists"
        else
            log_error "Missing required file: $file" "$file"
        fi
    done
}

check_expected_files() {
    log_info "Checking expected protocol files..."
    
    for file in "${EXPECTED_FILES[@]}"; do
        if [[ -f "$ROOT_DIR/$file" ]]; then
            log_success "$file exists"
        else
            log_warning "Missing expected file: $file (protocol will work but may be incomplete)" "$file"
        fi
    done
}

check_directory_structure() {
    log_info "Checking directory structure..."
    
    local expected_dirs=("system" "templates")
    
    for dir in "${expected_dirs[@]}"; do
        if [[ -d "$ROOT_DIR/$dir" ]]; then
            log_success "$dir/ directory exists"
        else
            if [[ "$FIX_MODE" == "true" ]]; then
                mkdir -p "$ROOT_DIR/$dir"
                log_fix "Created $dir/ directory"
            else
                log_warning "Missing directory: $dir/" "$dir"
            fi
        fi
    done
    
    # Check work/ directory (optional but recommended)
    if [[ -d "$ROOT_DIR/work" ]]; then
        log_success "work/ directory exists (recommended)"
    else
        log_info "work/ directory not found (optional - will use root for control files)"
    fi
}

check_manifest_version() {
    log_info "Checking manifest version..."
    
    local manifest="$ROOT_DIR/DR-X-MANIFEST.md"
    
    if [[ ! -f "$manifest" ]]; then
        return  # Already reported as missing
    fi
    
    # Extract version from first line
    local version_line
    version_line=$(head -n 1 "$manifest")
    
    if [[ "$version_line" =~ v([0-9]+\.[0-9]+) ]]; then
        local found_version="${BASH_REMATCH[1]}"
        log_success "Manifest version: v$found_version"
        
        # Check if version matches expected
        if [[ "$found_version" != "1.3" ]]; then
            log_warning "Manifest version v$found_version may be outdated (current: v1.3)" "$manifest"
        fi
    else
        log_warning "Could not detect manifest version from first line" "$manifest"
    fi
}

check_manifest_sections() {
    log_info "Checking manifest structure..."
    
    local manifest="$ROOT_DIR/DR-X-MANIFEST.md"
    
    if [[ ! -f "$manifest" ]]; then
        return
    fi
    
    local required_sections=(
        "DEFINITIONS"
        "IDENTITY"
        "COGNITIVE STYLE"
        "COMMUNICATION STYLE"
        "MODES"
        "ROLE DECLARATION"
        "ACTIVATION COMMANDS"
        "FILESYSTEM RULES"
        "EXECUTION LOGIC"
        "DISCOVERY MODE"
        "OUTPUT RULES"
        "STATE MAINTENANCE"
        "SAFETY"
    )
    
    for section in "${required_sections[@]}"; do
        if grep -q "## $section" "$manifest" 2>/dev/null; then
            log_success "Section found: $section"
        else
            log_error "Missing required section in manifest: $section" "$manifest"
        fi
    done
}

find_control_file() {
    local filename="$1"
    
    # Check in priority order: work/ > ./ > system/ > templates/
    if [[ -f "$ROOT_DIR/work/$filename" ]]; then
        echo "work/$filename"
    elif [[ -f "$ROOT_DIR/$filename" ]]; then
        echo "$filename"
    elif [[ -f "$ROOT_DIR/system/$filename" ]]; then
        echo "system/$filename"
    elif [[ -f "$ROOT_DIR/templates/$filename" ]]; then
        echo "templates/$filename"
    else
        echo ""
    fi
}

check_control_files() {
    log_info "Checking control file locations..."
    
    for file in "${CONTROL_FILES[@]}"; do
        local location
        location=$(find_control_file "$file")
        
        if [[ -n "$location" ]]; then
            log_success "$file found at: $location"
            
            # Warn if found in templates/ (not live state)
            if [[ "$location" == templates/* ]]; then
                log_warning "$file only exists in templates/ - this is NOT live state" "$location"
            fi
        else
            log_info "$file not found (will be created on first INIT if needed)"
        fi
    done
}

check_control_file_conflicts() {
    log_info "Checking for control file conflicts..."
    
    for file in "${CONTROL_FILES[@]}"; do
        local locations=()
        
        [[ -f "$ROOT_DIR/work/$file" ]] && locations+=("work/$file")
        [[ -f "$ROOT_DIR/$file" ]] && locations+=("$file")
        
        if [[ ${#locations[@]} -gt 1 ]]; then
            log_error "Conflict: $file exists in multiple locations: ${locations[*]}" "$file"
            log_info "  → Protocol will use: ${locations[0]} (highest priority)"
            log_info "  → Consider removing: ${locations[1]}"
        fi
    done
}

check_status_state() {
    log_info "Checking STATUS.md state validity..."
    
    local status_file
    status_file=$(find_control_file "STATUS.md")
    
    if [[ -z "$status_file" ]] || [[ "$status_file" == templates/* ]]; then
        log_info "No live STATUS.md found (will be created on INIT)"
        return
    fi
    
    local full_path="$ROOT_DIR/$status_file"
    
    # Extract current state
    local current_state=""
    
    # Try to find state in various formats
    if grep -q "^## Current State" "$full_path" 2>/dev/null; then
        # Look for state after "Current State" section
        current_state=$(awk '/^## Current State/{found=1; next} found && /^- [A-Z]+/{print $2; exit} found && /^[A-Z]+$/{print; exit}' "$full_path" | tr -d '- ')
    fi
    
    # Also check for inline state markers
    if [[ -z "$current_state" ]]; then
        for state in "${VALID_STATES[@]}"; do
            if grep -q "^- $state$\|^$state$\|: $state$" "$full_path" 2>/dev/null; then
                current_state="$state"
                break
            fi
        done
    fi
    
    if [[ -z "$current_state" ]]; then
        log_warning "Could not detect current state in $status_file" "$status_file"
        log_info "  → Valid states: ${VALID_STATES[*]}"
    else
        # Validate state
        local valid=false
        for state in "${VALID_STATES[@]}"; do
            if [[ "$current_state" == "$state" ]]; then
                valid=true
                break
            fi
        done
        
        if [[ "$valid" == "true" ]]; then
            log_success "STATUS.md state is valid: $current_state"
        else
            log_error "Invalid state in STATUS.md: '$current_state'" "$status_file"
            log_info "  → Valid states: ${VALID_STATES[*]}"
        fi
    fi
}

check_status_prd_consistency() {
    log_info "Checking STATUS/PRD consistency..."
    
    local status_file
    status_file=$(find_control_file "STATUS.md")
    local prd_file
    prd_file=$(find_control_file "PRD.md")
    
    if [[ -z "$status_file" ]] || [[ "$status_file" == templates/* ]]; then
        return
    fi
    
    local full_status="$ROOT_DIR/$status_file"
    
    # Check if status indicates BUILDING
    if grep -qE "BUILDING|REFINING|SHIPPING" "$full_status" 2>/dev/null; then
        if [[ -z "$prd_file" ]] || [[ "$prd_file" == templates/* ]]; then
            log_warning "STATUS indicates active work but no PRD.md found" "$status_file"
            log_info "  → Consider creating PRD.md or updating STATUS to DEFINING"
        else
            log_success "PRD.md exists for active work state"
        fi
    fi
}

check_goal_status_consistency() {
    log_info "Checking GOAL/STATUS consistency..."
    
    local goal_file
    goal_file=$(find_control_file "GOAL.md")
    local status_file
    status_file=$(find_control_file "STATUS.md")
    
    # Skip if both are templates or missing
    [[ "$goal_file" == templates/* ]] && goal_file=""
    [[ "$status_file" == templates/* ]] && status_file=""
    
    if [[ -n "$goal_file" ]] && [[ -z "$status_file" ]]; then
        log_warning "GOAL.md exists but STATUS.md is missing" "$goal_file"
        log_info "  → Protocol will create STATUS.md at DEFINING on next INIT"
    elif [[ -z "$goal_file" ]] && [[ -n "$status_file" ]]; then
        log_warning "STATUS.md exists but GOAL.md is missing" "$status_file"
        log_info "  → Consider creating GOAL.md to define the north star"
    elif [[ -n "$goal_file" ]] && [[ -n "$status_file" ]]; then
        log_success "Both GOAL.md and STATUS.md exist"
    fi
}

check_template_integrity() {
    log_info "Checking template integrity..."
    
    local templates=("GOAL.md" "STATUS.md" "PRD.md" "UX.md")
    
    for template in "${templates[@]}"; do
        local path="$ROOT_DIR/templates/$template"
        
        if [[ ! -f "$path" ]]; then
            continue  # Already warned about missing file
        fi
        
        # Check that template has placeholder content (not filled in)
        if grep -q "^- …$\|^(.*?)$" "$path" 2>/dev/null; then
            log_success "templates/$template has placeholder structure"
        else
            log_warning "templates/$template may have been filled in (should be format only)" "templates/$template"
        fi
    done
}

check_ethos_decision_link() {
    log_info "Checking ETHOS → DECISION reference..."
    
    local ethos="$ROOT_DIR/system/ETHOS.md"
    
    if [[ ! -f "$ethos" ]]; then
        return
    fi
    
    if grep -q "./system/DECISION.md\|system/DECISION.md" "$ethos" 2>/dev/null; then
        log_success "ETHOS.md correctly references system/DECISION.md"
    elif grep -q "DECISION.md" "$ethos" 2>/dev/null; then
        log_warning "ETHOS.md references DECISION.md but path may be incorrect" "$ethos"
    else
        log_info "ETHOS.md does not reference DECISION.md (optional)"
    fi
}

check_file_encoding() {
    log_info "Checking file encodings..."
    
    local all_md_files
    all_md_files=$(find "$ROOT_DIR" -name "*.md" -type f 2>/dev/null | head -50)
    
    local checked=0
    local issues=0
    
    while IFS= read -r file; do
        [[ -z "$file" ]] && continue
        ((checked++))
        
        # Check for UTF-8 BOM (which can cause issues)
        if head -c 3 "$file" 2>/dev/null | grep -q $'\xef\xbb\xbf'; then
            log_warning "File has UTF-8 BOM: ${file#$ROOT_DIR/}" "$file"
            ((issues++))
        fi
        
        # Check for Windows line endings
        if file "$file" 2>/dev/null | grep -q "CRLF"; then
            log_warning "File has Windows line endings (CRLF): ${file#$ROOT_DIR/}" "$file"
            ((issues++))
        fi
    done <<< "$all_md_files"
    
    if [[ $issues -eq 0 ]] && [[ $checked -gt 0 ]]; then
        log_success "All $checked Markdown files have clean encoding"
    fi
}

check_next_action_format() {
    log_info "Checking → NEXT ACTION format in protocol files..."
    
    local protocol_files=(
        "system/ETHOS.md"
        "system/DECISION.md"
        "system/RETRO.md"
    )
    
    for file in "${protocol_files[@]}"; do
        local path="$ROOT_DIR/$file"
        
        if [[ ! -f "$path" ]]; then
            continue
        fi
        
        if grep -q "^→ NEXT ACTION:" "$path" 2>/dev/null; then
            log_success "$file has correct → NEXT ACTION format"
        else
            log_warning "$file missing → NEXT ACTION footer" "$file"
        fi
    done
}

check_license_present() {
    log_info "Checking license..."
    
    if [[ -f "$ROOT_DIR/LICENSE" ]]; then
        if grep -q "DR-X-V3" "$ROOT_DIR/LICENSE" 2>/dev/null; then
            log_success "LICENSE file present with DR-X-V3 license"
        else
            log_warning "LICENSE file exists but may not be DR-X-V3" "LICENSE"
        fi
    else
        log_warning "No LICENSE file found" "LICENSE"
    fi
}

# ============================================================================
# OUTPUT
# ============================================================================

print_summary() {
    if [[ "$JSON_MODE" == "true" ]]; then
        echo "{"
        echo "  \"version\": \"$VERSION\","
        echo "  \"errors\": $ERRORS,"
        echo "  \"warnings\": $WARNINGS,"
        echo "  \"fixes\": $FIXES,"
        echo "  \"results\": ["
        local first=true
        for result in "${RESULTS[@]}"; do
            if [[ "$first" == "true" ]]; then
                first=false
            else
                echo ","
            fi
            echo -n "    $result"
        done
        echo ""
        echo "  ]"
        echo "}"
    else
        echo ""
        echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${BOLD}VALIDATION SUMMARY${NC}"
        echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        
        if [[ $ERRORS -eq 0 ]] && [[ $WARNINGS -eq 0 ]]; then
            echo -e "${GREEN}${BOLD}✓ ALL CHECKS PASSED${NC}"
        elif [[ $ERRORS -eq 0 ]]; then
            echo -e "${YELLOW}${BOLD}⚠ PASSED WITH WARNINGS${NC}"
        else
            echo -e "${RED}${BOLD}✗ VALIDATION FAILED${NC}"
        fi
        
        echo ""
        echo -e "  Errors:   ${RED}$ERRORS${NC}"
        echo -e "  Warnings: ${YELLOW}$WARNINGS${NC}"
        [[ $FIXES -gt 0 ]] && echo -e "  Fixed:    ${GREEN}$FIXES${NC}"
        echo ""
        
        if [[ $ERRORS -gt 0 ]]; then
            echo -e "${RED}Fix errors before running INIT.${NC}"
        elif [[ $WARNINGS -gt 0 ]]; then
            echo -e "${YELLOW}Warnings are informational. Protocol will still work.${NC}"
        else
            echo -e "${GREEN}Protocol is ready. Type INIT to activate.${NC}"
        fi
        
        echo ""
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --strict)
                STRICT_MODE=true
                ;;
            --fix)
                FIX_MODE=true
                ;;
            --json)
                JSON_MODE=true
                ;;
            --help|-h)
                echo "inner-loop-os Validator v$VERSION"
                echo ""
                echo "Usage: $0 [--strict] [--fix] [--json]"
                echo ""
                echo "Options:"
                echo "  --strict  Treat warnings as errors"
                echo "  --fix     Attempt to fix simple issues"
                echo "  --json    Output results as JSON"
                echo ""
                exit 0
                ;;
            *)
                echo "Unknown option: $arg"
                echo "Use --help for usage information"
                exit 2
                ;;
        esac
    done
    
    # Reapply color settings based on JSON mode
    if [[ "$JSON_MODE" == "true" ]]; then
        RED=''
        YELLOW=''
        GREEN=''
        BLUE=''
        BOLD=''
        NC=''
    fi
    
    if [[ "$JSON_MODE" != "true" ]]; then
        echo ""
        echo -e "${BOLD}inner-loop-os Validator v$VERSION${NC}"
        echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
        echo ""
    fi
    
    # Run all checks
    check_required_files
    check_expected_files
    check_directory_structure
    check_manifest_version
    check_manifest_sections
    check_control_files
    check_control_file_conflicts
    check_status_state
    check_status_prd_consistency
    check_goal_status_consistency
    check_template_integrity
    check_ethos_decision_link
    check_file_encoding
    check_next_action_format
    check_license_present
    
    # Print summary
    print_summary
    
    # Determine exit code
    if [[ $ERRORS -gt 0 ]]; then
        exit 1
    elif [[ "$STRICT_MODE" == "true" ]] && [[ $WARNINGS -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

main "$@"
