# autohooks

Bash script for calculating automatic MOZ_BUILD_HOOK

Just download and add:

```haskell
ac_add_options MOZ_BUILD_HOOK=$(/path/to/autohooks.sh)
```

to your mozconfig. This will use `bookmarks/central` as merge-base.
If a different merge-base is needed call `autohooks.sh <base-commit>` instead.
