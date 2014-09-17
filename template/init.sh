#!/usr/bin/env bash
#abort if any command fails
set -o errexit

initial_push=1

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
elif [[ $1 = "-n" || $1 = "--name" ]]; then
    shift
    name=$1
    shift
elif [[ $1 = "--no-push" ]]; then
    initial_push=0
    shift
else
    break
fi
done


function status_message {
    echo
    echo "-----> $*"
    echo
}

if [[ $repo && $tag ]]; then
    # Clean out directory
    find . -type f ! -name 'init.sh' | xargs rm

    status_message "Downloading $repo at tag $tag"

    # Download release and extract here
    curl -Lk https://github.com/${repo}/archive/${tag}.tar.gz | tar -xz --strip-components=1

    # Extract package name from package.json
    pkg_name=`node -pe 'JSON.parse(process.argv[1]).name' "$(cat package.json)"`

    if [[ $name ]]; then
        status_message "Setting application name as ${name}"
        LC_ALL=C find . -type f -exec sed -i "" "s/${pkg_name}/${name}/g" {} ";"
    else
        status_message "No name found... using packages name -> ${pkg_name}"
    fi

    if [ $initial_push -eq 1 ]; then
        status_message "Doing initial push"
        git add -A
        git commit -m 'Initial boilerplate push'
        git push origin
    fi

    status_message "Finished! Enjoy!"

    # Goodbye cruel world
    rm -- $0
else
    # WHAT DO YOU WANT FROM ME?
    echo "Missing repo and/or tag."
fi
