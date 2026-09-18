#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <full-beacon-commit-sha> <image-tag>" >&2
    exit 2
fi

revision="$1"
image_tag="$2"
version="${image_tag#*:}"
upstream_version="1.2.5"
upstream_revision="9f328938a355b778b037435dbc61ef89731f71ad"
container_name="beacon-phase3-5-smoke"
data_volume="beacon-phase3-5-data"

if [[ ! "$revision" =~ ^[0-9a-f]{40}$ ]]; then
    echo "The Beacon revision must be a full 40-character Git SHA." >&2
    exit 2
fi

cleanup() {
    docker rm -f "$container_name" >/dev/null 2>&1 || true
    docker volume rm "$data_volume" >/dev/null 2>&1 || true
    rm -f /tmp/beacon-phase3-5-login.html /tmp/beacon-phase3-5-manifest.json /tmp/beacon-phase3-5-favicon.ico /tmp/beacon-phase3-5-common.js
}
trap cleanup EXIT

host_node_available=false
if command -v node >/dev/null 2>&1; then
    node tools/check-phase3-5.cjs
    host_node_available=true
fi
cleanup

build_date="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
docker build \
    --build-arg BEACON_VERSION="$version" \
    --build-arg BEACON_REVISION="$revision" \
    --build-arg BEACON_BUILD_DATE="$build_date" \
    --build-arg BEACON_UPSTREAM_VERSION="$upstream_version" \
    --build-arg BEACON_UPSTREAM_REVISION="$upstream_revision" \
    -t "$image_tag" \
    -f docker/Dockerfile .

if [[ "$host_node_available" == false ]]; then
    docker run --rm \
        --entrypoint node \
        -v "$PWD:/work:ro" \
        -w /work \
        "$image_tag" \
        tools/check-phase3-5.cjs
fi

declare -A expected_labels=(
    [org.opencontainers.image.version]="$version"
    [org.opencontainers.image.revision]="$revision"
    [org.opencontainers.image.created]="$build_date"
    [com.hudsonhelm.beacon.upstream.version]="$upstream_version"
    [com.hudsonhelm.beacon.upstream.revision]="$upstream_revision"
)

for label in "${!expected_labels[@]}"; do
    actual_value="$(docker image inspect "$image_tag" --format "{{ index .Config.Labels \"$label\" }}")"
    if [[ "$actual_value" != "${expected_labels[$label]}" ]]; then
        echo "Image label $label did not match the requested build metadata." >&2
        exit 1
    fi
done

docker run -d \
    --name "$container_name" \
    -p 127.0.0.1:10443:443 \
    -e HOSTNAME=localhost \
    -e ALLOW_NEW_ACCOUNTS=false \
    -v "$data_volume:/opt/meshcentral/meshcentral-data" \
    "$image_tag" >/dev/null

for _ in $(seq 1 90); do
    if curl -kfsS https://127.0.0.1:10443/login >/tmp/beacon-phase3-5-login.html; then
        break
    fi
    if [[ "$(docker inspect --format '{{.State.Running}}' "$container_name")" != "true" ]]; then
        docker logs "$container_name" >&2
        exit 1
    fi
    sleep 2
done

curl -kfsS https://127.0.0.1:10443/login >/tmp/beacon-phase3-5-login.html
curl -kfsS https://127.0.0.1:10443/manifest.json >/tmp/beacon-phase3-5-manifest.json
curl -kfsS https://127.0.0.1:10443/favicon.ico >/tmp/beacon-phase3-5-favicon.ico
curl -kfsS https://127.0.0.1:10443/scripts/common-0.0.1.js >/tmp/beacon-phase3-5-common.js

grep -q '<title>Beacon Remote - Login</title>' /tmp/beacon-phase3-5-login.html
test -s /tmp/beacon-phase3-5-common.js
if grep -Eq 'MeshCentral Assistant|MeshCentral Agent|Mesh Agent|>MeshCentral<' /tmp/beacon-phase3-5-login.html; then
    echo "Upstream product branding remains on the login page." >&2
    exit 1
fi
jq -e '.name == "Beacon Remote" and .short_name == "Beacon Remote"' /tmp/beacon-phase3-5-manifest.json >/dev/null
docker exec "$container_name" jq -e '
    .domains[""].title == "Beacon Remote" and
    .domains[""].agentCustomization.displayName == "Beacon Agent" and
    .domains[""].assistantCustomization.title == "Beacon Assistant" and
    .domains[""].agentFileInfo.productName == "Beacon Agent"
' /opt/meshcentral/meshcentral-data/config.json >/dev/null
docker exec "$container_name" test -s /opt/meshcentral/meshcentral-data/beacon-agent.ico
docker exec "$container_name" test -s /opt/meshcentral/meshcentral/public/favicon.ico

echo "Phase 3.5 branded image build and HTTPS smoke test passed for $image_tag ($revision)."
