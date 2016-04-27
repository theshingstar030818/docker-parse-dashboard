#!/usr/bin/env bash

set -e

cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

url='git://github.com/yongjhih/docker-parse-dashboard'

generate-version() {
	local version=$1

	commit="$(git log -1 --format='format:%H')"

	versionAliases=()
	if [ "$version" == 'master' ]; then
		echo "latest: ${url}@${commit} ."
	else
		echo "${version}: ${url}@${commit} docker/${version}"
	fi
}

echo '# maintainer: Andrew Chen <yongjhih@gmail.com> (@yongjhih)'

versions=( docker/*/Dockerfile )
versions=( "${versions[@]#docker/}" )
versions=( "${versions[@]%/*}" master )

for version in "${versions[@]}"; do
	generate-version "$version"
done
