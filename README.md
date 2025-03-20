# autohooks

Bash script for calculating automatic MOZ_BUILD_HOOK

Just download and add:

```haskell
ac_add_options MOZ_BUILD_HOOK=$(/path/to/autohooks.sh)
```

to your mozconfig. This will use `bookmarks/central` as merge-base.

```
hooks -h
Usage: hooks [-b <merge-base>] [-t template] [-h]
  -h               Show this help
  -t FILE          Add template to hooks file
  -b <MERGE-BASE>  Use <MERGE-BASE> as merge-base
```

If a different merge-base is needed call `autohooks.sh -b <MERGE-BASE>` instead.

Use `autohooks.sh -t FILE` to include the contents of FILE as prefix of the hooks file.

This can of course be combined to `autohooks.sh -t FILE -b <MERGE-BASE>`.
