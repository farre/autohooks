#!/usr/bin/bash
base=$(git merge-base HEAD ${1-bookmarks/central} 2>/dev/null)
directories=$(for file in $(git diff --name-only $base HEAD)
do
  directory=$(dirname $file)
  if [ -f "${directory}/moz.build" ]
  then
    echo $directory
  fi
done | sort -u)
temp=$(mktemp)
for directory in $directories
do
  echo "if RELATIVEDIR.startswith(\"${directory}\"):" >> $temp
  echo "    COMPILE_FLAGS[\"OPTIMIZE\"] = []" >> $temp
done
tmpdir=${TMPDIR-/tmp}
hooks=$(ls ${tmpdir}/*.${base} 2>/dev/null | awk '{print $1}')
if [ -z "${hooks}" ] || [ ! diff -q $hooks $temp &>/dev/null ]
then
  rm ${tmpdir}/*.${base} 2>/dev/null
  hooks=$(mktemp --suffix .${base})
  echo $hooks
  mv $temp $hooks
fi

echo $hooks
