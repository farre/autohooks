# autohooks

## Purpose

**autohooks.sh** is a Bash script that generates a MOZ_BUILD_HOOK file automatically for Mozilla builds. It detects which directories have changed between the current `HEAD` and a specified Git merge base (defaulting to `bookmarks/central`), and then disables compiler optimizations (`COMPILE_FLAGS["OPTIMIZE"] = []`) in those directories.

By selectively disabling optimizations where you’re actively working, you gain faster compile times and easier debugging, without needing to manually edit `moz.build` in each changed directory or adjust a MOZ_BUILD_HOOK file manually.

---

## Quick Setup

1. **Make the script executable**:

    `chmod +x /path/to/autohooks.sh`

2. **Add to your `.mozconfig`**:

    `ac_add_options MOZ_BUILD_HOOK=$(/path/to/autohooks.sh)`

   This uses `bookmarks/central` as the merge base by default.

---

## Usage
```bash
    autohooks.sh [-h] [-b <MERGE_BASE>] [-t <TEMPLATE>]

    Options:
      -h               Show help message
      -b <MERGE_BASE>  Specify a custom merge base (default: bookmarks/central)
      -t <TEMPLATE>    Include the contents of <TEMPLATE> at the start of the hooks file
```

---

### Common Examples

- **Default**:

      `ac_add_options MOZ_BUILD_HOOK=$(/path/to/autohooks.sh)`

  Uses `bookmarks/central` as the merge base.

- **Custom Merge Base**:

      `ac_add_options MOZ_BUILD_HOOK=$(/path/to/autohooks.sh -b mybranch)`

  Disables optimization in directories changed between `HEAD` and `mybranch`.

- **Adding a Template**:

      `ac_add_options MOZ_BUILD_HOOK=$(/path/to/autohooks.sh -t /path/to/template_hooks.txt)`

  Prepends custom flags or logic from `template_hooks.txt` to the generated hooks file.

- **Combine Both**:

      `ac_add_options MOZ_BUILD_HOOK=$(/path/to/autohooks.sh -t /path/to/template_hooks.txt -b mybranch)`

---

## How It Works

1. **Detect Changed Directories**  
   The script uses:

       `git diff --name-only <merge-base> HEAD`

   to find modified files, then checks if their directories contain a `moz.build` file.

2. **Disable Optimization**  
   For each directory with changes, the script appends:
```
       if RELATIVEDIR.startswith("<directory>"):
           COMPILE_FLAGS["OPTIMIZE"] = []
```
   to a temporary hooks file.

3. **Reuse or Create Hooks File**  
   If an existing hooks file in `/tmp` is identical to the new one, the script reuses it; otherwise, it saves the new file under a name based on the merge base. Finally, it prints the file path for `MOZ_BUILD_HOOK` to pick up.

---

## When to Use autohooks.sh

- You frequently switch between branches and need to disable optimizations in new or modified directories on each checkout.
- You want to centralize all your “disable optimization” logic without editing individual `moz.build` files, or manually updating a MOZ_BUILD_HOOK file.
- You have a template of flags or commands you always want included (e.g., special debug flags).

This script simplifies the process of selectively disabling optimization, letting you focus on development rather than manual build configuration.


