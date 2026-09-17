#!/usr/bin/env bash
set -Eeuo pipefail

readonly beacon_version="${BEACON_VERSION:-0.1.0-hudson.1}"
readonly beacon_revision="${BEACON_REVISION:-$(git rev-parse HEAD 2>/dev/null || true)}"
readonly beacon_build_date="${BEACON_BUILD_DATE:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"
readonly upstream_version="${BEACON_UPSTREAM_VERSION:-1.2.5}"
readonly upstream_revision="${BEACON_UPSTREAM_REVISION:-9f328938a355b778b037435dbc61ef89731f71ad}"
readonly image_name="${BEACON_IMAGE:-beacon-remote:${beacon_version}}"
readonly container_name="beacon-phase3-smoke"
readonly smoke_port="${BEACON_SMOKE_PORT:-10443}"

if [[ ! "${beacon_revision}" =~ ^[0-9a-f]{40}$ ]]; then
    echo "BEACON_REVISION must be a full 40-character Git commit SHA." >&2
    exit 1
fi

cleanup() {
    docker rm -f "${container_name}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker build \
    --file docker/Dockerfile \
    --tag "${image_name}" \
    --build-arg "BEACON_VERSION=${beacon_version}" \
    --build-arg "BEACON_REVISION=${beacon_revision}" \
    --build-arg "BEACON_BUILD_DATE=${beacon_build_date}" \
    --build-arg "BEACON_UPSTREAM_VERSION=${upstream_version}" \
    --build-arg "BEACON_UPSTREAM_REVISION=${upstream_revision}" \
    .

declare -A expected_labels=(
    [org.opencontainers.image.version]="${beacon_version}"
    [org.opencontainers.image.revision]="${beacon_revision}"
    [org.opencontainers.image.created]="${beacon_build_date}"
    [com.hudsonhelm.beacon.upstream.version]="${upstream_version}"
    [com.hudsonhelm.beacon.upstream.revision]="${upstream_revision}"
)

for label in "${!expected_labels[@]}"; do
    actual_value="$(docker image inspect "${image_name}" --format "{{ index .Config.Labels \"${label}\" }}")"
    if [[ "${actual_value}" != "${expected_labels[${label}]}" ]]; then
        echo "Image label ${label} did not match the requested build metadata." >&2
        exit 1
    fi
done

docker run --detach \
    --name "${container_name}" \
    --publish "127.0.0.1:${smoke_port}:443" \
    --env HOSTNAME=localhost \
    --env ALLOW_NEW_ACCOUNTS=false \
    "${image_name}" >/dev/null

for attempt in {1..60}; do
    if curl --fail --insecure --silent --show-error "https://127.0.0.1:${smoke_port}/" >/dev/null 2>&1; then
        echo "Beacon image ${image_name} started successfully."
        echo "Beacon revision: ${beacon_revision}"
        echo "Upstream revision: ${upstream_revision}"
        exit 0
    fi

    if [[ "$(docker inspect --format '{{.State.Running}}' "${container_name}")" != "true" ]]; then
        docker logs "${container_name}" >&2
        exit 1
    fi

    sleep 2
done

docker logs "${container_name}" >&2
echo "Beacon image did not become ready on the loopback smoke-test port." >&2
exit 1
