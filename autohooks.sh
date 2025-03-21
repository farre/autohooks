#!/usr/bin/bash
while getopts "hb:t:" option; do
  case $option in
    b) mergebase=$OPTARG
    ;;
    t) template=$OPTARG
    ;;
    h) echo "Usage: $(basename $0) [-h] [-b <merge-base>] [-t template]"
       echo "  -h               Show this help"
       echo "  -t FILE          Add FILE as template for hooks file"
       echo "  -b <MERGE_BASE>  Use <MERGE-BASE> as merge-base"
       exit 0
    ;;
  esac
done
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
base=$(git merge-base HEAD ${mergebase-bookmarks/central} 2>/dev/null)
files=$(git diff --name-only $base HEAD 2>/dev/null)
elif [ -d .hg ] || hg root >/dev/null 2>&1; then
base=$(hg log -r "${mergebase-parents(first(outgoing()))}" --template '{node}\n')
files=$(hg status -n --rev "${base}":"last(outgoing())")
fi

directories=$(for file in $files; do
  directory=$(dirname $file)
  if [ -f "${directory}/moz.build" ];  then
    echo $directory
  fi
done | sort -u)
temp=$(mktemp)
if [ -n "${template}" ]; then
  cat "${template}" 2>/dev/null > $temp
fi
for directory in $directories; do
  echo "if RELATIVEDIR.startswith(\"${directory}\"):" >> $temp
  echo "    COMPILE_FLAGS[\"OPTIMIZE\"] = []" >> $temp
done
tmpdir=${TMPDIR-/tmp}
hooks=$(ls ${tmpdir}/*.${base} 2>/dev/null | awk '{print $1}')
if [ -z "${hooks}" ] || ! diff -q $hooks $temp &>/dev/null; then
  rm ${tmpdir}/*.${base} 2>/dev/null
  hooks=$(mktemp --suffix .${base})
  mv $temp $hooks
fi
echo $hooks
