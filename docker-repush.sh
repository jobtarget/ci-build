set -e # Abort on first error

green "🦑 Pulling down image: ${1}"
docker pull $1

green "🏷 Retagging to: ${2}"
docker tag $1 $2

green "🛸 Pushing Docker image: ${2}"
docker push $2