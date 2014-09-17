#!/usr/bin/env bash
#abort if any command fails
set -o errexit

# Parse arg flags
while : ; do
if [[ $1 = "-r" || $1 = "--repo" ]]; then
    shift
    repo=$1
    shift
elif [[ $1 = "-t" || $1 = "--tag" ]]; then
    shift
    tag=$1
    shift
else
    break
fi
done

if [[ $repo && $tag ]]; then
    # Clean out directory
    find . type -f ! -name 'init.sh' | xargs rm
    echo
    echo "------> Downloading $repo at tag $tag"
    echo
    # Download release and extract here
    curl -Lk https://github.com/${repo}/archive/${tag}.tar.gz | tar -xz --strip-components=1
    echo
    echo "------> Finished! Enjoy!"
    echo
    # Goodbye cruel world
    rm -- $0
else
    # WHAT DO YOU WANT FROM ME?
    echo "Missing repo and/or tag."
fi
