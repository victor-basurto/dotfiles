# Tree with Optional Depth
# usage:
#   lt        # depth 3
#   lt 2      # depth 2
#   lt 4 src  # depth 4 in src
lt() {
local level_arg=3

  if [[ -n "$1" && "$1" =~ ^[0-9]+$ ]]; then
    level_arg="$1"
    shift
  fi

  local root
  root="$(find_project_root)"

  eza \
    --tree \
    --level="$level_arg" \
    --group-directories-first \
    "$root" \
    "$@"
}

# Show Only Folders (Project Structure View)
# ltdirs
# ltdirs src
ltdirs() {
  eza \
    --tree \
    -D \
    --group-directories-first \
    "$@"
}

# Clean Frontend Project View (Ignore Junk)
# This is optimized for a Next.js + TypeScript project.
# It hides:
#   node_modules
#   .git
#   .next
#   .turbo
#   .vercel
#   dist
#   build
#   coverage
# Usage:
#   ltclean
#   ltclean src
ltclean() {
 local root
  root="$(find_project_root)"

  local ignore_list=".git"

  # Detect Next.js
  if [[ -f "$root/next.config.js" ]] || [[ -d "$root/.next" ]]; then
    ignore_list="$ignore_list|node_modules|.next|.turbo|.vercel|dist|build|coverage"
  
  # Detect Node
  elif [[ -f "$root/package.json" ]]; then
    ignore_list="$ignore_list|node_modules|dist|build|coverage"

  # Detect Python
  elif [[ -f "$root/pyproject.toml" ]] || [[ -f "$root/requirements.txt" ]]; then
    ignore_list="$ignore_list|__pycache__|.venv|venv|dist|build|.pytest_cache"
  fi

  eza \
    --tree \
    -D \
    --group-directories-first \
    --ignore-glob="$ignore_list" \
    "$root"
}
# Full Project Overview (Folders + Important Files Only)
# Shows folders
# Shows key files (package.json, tsconfig.json, etc.)
# Hides junk folders
# usage:
#   ltproject
ltproject() {
  eza \
    --tree \
    --icons=always \
    --color=always \
    --group-directories-first \
    --ignore-glob="node_modules|.git|.next|.turbo|.vercel|dist|build|coverage" \
    --git-ignore \
    "$@"
}
# Next.js Structure Viewer
# This version:
#   Detects Next.js
#   Shows only important architecture folders
#   Ignores node_modules / .next / etc.
#   Only shows directories
#   Works from anywhere inside the repo
# usage:
#   ltnext              → default (app + components + lib)
#   ltnext components   → only components
#   ltnext routes       → only app/ (App Router)
#   ltnext assets       → public/ or assets/
#   ltnext 2 components → depth control + filter
ltnext() {
local level=3
  local scope=""
  local root

  # If first argument is a number → depth
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    level="$1"
    shift
  fi

  # If argument remains → scope
  if [[ -n "$1" ]]; then
    scope="$1"
  fi

  root="$(find_nextjs_root)"

  if [[ -z "$root" ]]; then
    echo "Not inside a Next.js app."
    return 1
  fi

  local targets=()

  # Helper to safely add dir
  add_dir() {
    [[ -d "$1" ]] && targets+=("$1")
  }

  case "$scope" in
    components)
      add_dir "$root/components"
      add_dir "$root/src/components"
      ;;
    routes)
      add_dir "$root/app"
      add_dir "$root/src/app"
      ;;
    assets)
      add_dir "$root/public"
      add_dir "$root/assets"
      add_dir "$root/src/assets"
      ;;
    "")
      # Default architecture view
      add_dir "$root/src/app"
      add_dir "$root/src/components"
      add_dir "$root/src/lib"

      add_dir "$root/app"
      add_dir "$root/components"
      add_dir "$root/lib"
      ;;
    *)
      echo "Unknown scope: $scope"
      echo "Valid scopes: components | routes | assets"
      return 1
      ;;
  esac

  if [[ ${#targets[@]} -eq 0 ]]; then
    echo "No matching directories found."
    return 1
  fi

  eza \
    --tree \
    --level="$level" \
    -D \
    --group-directories-first \
    --ignore-glob='.git|node_modules|.next|.turbo|dist|build|coverage' \
    "${targets[@]}"
}
# Auto-Detect Project Root
# checking for:
#   .git
#   package.json
#   pyproject.toml
#   requirements.txt
#   go.mod
#   etc.
#
# Smart Root Finder
find_project_root() {
  local dir="$PWD"

  while [[ "$dir" != "/" ]]; do
    # Git repo always wins
    if git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      echo "$dir"
      return
    fi

    # Language markers
    if [[ -f "$dir/package.json" ]] || \
       [[ -f "$dir/pyproject.toml" ]] || \
       [[ -f "$dir/requirements.txt" ]] || \
       [[ -f "$dir/go.mod" ]] || \
       [[ -f "$dir/Cargo.toml" ]]; then
      echo "$dir"
      return
    fi

    dir="$(dirname "$dir")"
  done

  echo "$PWD"
}
# Next.js Root Finder
find_nextjs_root() {
  local dir="$PWD"

  while [[ "$dir" != "/" ]]; do
    # Check for next.config.js/ts/mjs
    if [[ -f "$dir/next.config.js" ]] || \
       [[ -f "$dir/next.config.mjs" ]] || \
       [[ -f "$dir/next.config.ts" ]]; then
      echo "$dir"
      return
    fi

    # Check package.json for Next dependency
    if [[ -f "$dir/package.json" ]] && grep -q '"next"' "$dir/package.json"; then
      echo "$dir"
      return
    fi

    dir="$(dirname "$dir")"
  done

  return 1
}
# Print architectural directory tree (folders only) with exclusions
#
# Uses eza to display a clean folder-only tree view with:
# - icons + color
# - configurable depth
# - ability to exclude one or multiple folders
# - safe argument parsing
#
# ⚠️ Note:
# Uses --ignore-glob with wildcard matching:
#   *folder* (matches anywhere in path/name)
#
# Usage:
#
# ▶ Basic usage (current directory)
# lt-dirs-exclude tmux
#
# ▶ Exclude multiple folders
# lt-dirs-exclude node_modules .git build
#
# ▶ Limit tree depth
# lt-dirs-exclude tmux --depth 2
#
# ▶ Run on a specific path
# lt-dirs-exclude tmux --path ~/projects/app
#
# ▶ Combine all options
# lt-dirs-exclude node_modules .git dist --depth 3 --path ~/projects/app
#
# Behavior:
# - Only directories are shown (--only-dirs)
# - Matches any folder containing the pattern (glob: *name*)
# - Does NOT modify or delete any files
# - Safe read-only tree visualization tool
#
lt-dirs-exclude() {
  local target_path="."
  local depth=0
  local excludes=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --path) target_path="$2"; shift 2 ;;
      --depth) depth="$2"; shift 2 ;;
      *) excludes+=("$1"); shift ;;
    esac
  done

  if [[ ${#excludes[@]} -eq 0 ]]; then
    echo "❌ Error: Please provide at least one folder name to exclude."
    return 1
  fi

  local ignore_pattern=""
  for folder in "${excludes[@]}"; do
    if [[ -z "$ignore_pattern" ]]; then
      ignore_pattern="*${folder}*"
    else
      ignore_pattern="${ignore_pattern}|*${folder}*"
    fi
  done

  local depth_arg=()
  if [[ $depth -gt 0 ]]; then
    depth_arg=("--level=$depth")
  fi

  eza --tree --only-dirs --icons=always --color=always \
      --ignore-glob="$ignore_pattern" \
      "${depth_arg[@]}" \
      "$target_path"
}
