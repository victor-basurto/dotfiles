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
# Print Architectual Tree only but exclude folder
# This function also allows you to set the deep level
#  One folder to exclude
#  Multiple folders to exclude
#  Error checking for each folder
#  Folders‑only tree
#  Icons + color
#  No eza ignore flags (since eza removed them)
#  No modification to your real directory
# usage:
#   exclude one folder:
#   lt-dirs-exclude serialization
#
#   exclude multiple folders:
#   lt-dirs-exclude serialization
#   
#   exclude folders inside a specific path
#   lt-dirs-exclude node_modules .git build -Path C:\Projects\App
#
#   exclude multiple folder with 2 depth delimiter
#   lt-dirs-exclude serialization platform -Depth 2
lt-dirs-exclude() {
  local path="."
  local depth=0
  local excludes=()
  
  # Parse arguments
  # This separates the 'ExcludeFolders' from the optional --path and --depth flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --path) path="$2"; shift 2 ;;
      --depth) depth="$2"; shift 2 ;;
      *) excludes+=("$1"); shift ;;
    esac
  done

  # Check if at least one folder was provided to exclude
  if [[ ${#excludes[@]} -eq 0 ]]; then
    echo "❌ Error: Please provide at least one folder name to exclude."
    return 1
  fi

  # Build the ignore pattern
  # We join the array with '|' and wrap in wildcards
  local ignore_pattern=""
  for folder in "${excludes[@]}"; do
    if [[ -z "$ignore_pattern" ]]; then
      ignore_pattern="*${folder}*"
    else
      ignore_pattern="${ignore_pattern}|*${folder}*"
    fi
  done

  # Build depth argument
  local depth_arg=()
  if [[ $depth -gt 0 ]]; then
    depth_arg=("--level=$depth")
  fi

  # Execute eza
  eza --tree --only-dirs --icons=always --color=always \
      --ignore-glob="$ignore_pattern" \
      "${depth_arg[@]}" \
      "$path"
}

# EZA Theme
export EZA_CONFIG_DIR="$HOME/.config/.dotfiles/eza"

