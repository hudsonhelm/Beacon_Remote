'use strict';

const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
let failures = 0;

function pass(message) { console.log(`PASS: ${message}`); }
function fail(message) { console.error(`FAIL: ${message}`); failures++; }
function read(relativePath) { return fs.readFileSync(path.join(root, relativePath), 'utf8'); }
function exists(relativePath) { return fs.existsSync(path.join(root, relativePath)); }
function expect(condition, message) { condition ? pass(message) : fail(message); }

const branding = JSON.parse(read('docker/beacon-branding.json'));
const domain = branding.domains[''];

expect(domain.title === 'Beacon Remote', 'product title is Beacon Remote');
expect(domain.title2 === 'Hudson Helm', 'parent business is Hudson Helm');
expect(domain.siteStyle === 3 && domain.showModernUIToggle === false, 'modern UI is the only normal operator UI');
expect(domain.agentCustomization.displayName === 'Beacon Agent', 'managed endpoint is Beacon Agent');
expect(domain.agentCustomization.serviceName === 'beaconagent', 'agent service uses a stable compatibility-safe identifier');
expect(domain.agentCustomization.fileName === 'BeaconAgent', 'generated agent filename is branded');
expect(domain.agentFileInfo.productName === 'Beacon Agent', 'Windows executable product metadata is branded');
expect(domain.agentFileInfo.originalFilename === 'BeaconAgent.exe', 'Windows original filename metadata is branded');
expect(domain.assistantCustomization.title === 'Beacon Assistant', 'assistant title is branded');
expect(domain.assistantCustomization.fileName === 'BeaconAssistant', 'assistant download filename is branded');
expect(domain.notificationMessages.Title === 'Beacon Remote', 'endpoint notification title is branded');
expect(domain.consentMessages.Title === 'Beacon Remote', 'endpoint consent title is branded');

const requiredAssets = [
    'Images/Brand/beacon.ico',
    'Images/Brand/Web/beacon-header-450x66.png',
    'Images/Brand/Web/beacon-login-light-512.png',
    'Images/Brand/PNG/Application/beacon-app-128.png',
    'Images/Brand/PNG/Application/beacon-app-512.png',
    'Images/Brand/Browser/favicon.ico',
    'Images/Brand/Browser/favicon-16.png',
    'Images/Brand/Browser/favicon-32.png',
    'Images/Brand/Browser/favicon-180.png',
    'Images/Brand/Browser/favicon-512.png',
    'Images/Brand/Installer/beacon-installer-sidebar-164x314.bmp',
    'Images/Brand/Lockups/beacon-remote-lockup-1200x400.png'
];
for (const asset of requiredAssets) {
    expect(exists(asset) && fs.statSync(path.join(root, asset)).size > 0, `asset exists: ${asset}`);
}

const dockerfile = read('docker/Dockerfile');
const entrypoint = read('docker/entrypoint.sh');
expect(dockerfile.includes('BEACON_BRANDING="true"'), 'container enables Beacon branding by default');
expect(dockerfile.includes('ARG DISABLE_MINIFY="false"'), 'container generates the production minified web assets');
expect(dockerfile.includes('COPY ./Images/Brand /opt/meshcentral/beacon-brand'), 'container packages the approved asset set');
expect(dockerfile.includes('/opt/meshcentral/meshcentral/public/favicon.ico'), 'favicon is installed without activating a partial web override');
expect(entrypoint.includes("jq -s '.[0] * .[1]'"), 'branding overlay merges into persistent configuration');
expect(entrypoint.includes('isolated upstream comparison only'), 'branding opt-out is explicitly restricted');

const activeSurfaces = [
    'views/default3.handlebars',
    'views/agentinvite.handlebars',
    'views/invite.handlebars',
    'views/login2.handlebars',
    'views/message2.handlebars',
    'views/download2.handlebars',
    'views/sharing.handlebars',
    'views/sharing-mobile.handlebars',
    'emails/mesh-invite.html',
    'emails/mesh-invite.txt'
];
const forbiddenVisibleNames = ['MeshCentral Assistant', 'MeshCentral Agent', 'Mesh Agent'];
for (const surface of activeSurfaces) {
    const text = read(surface);
    for (const name of forbiddenVisibleNames) {
        expect(!text.includes(name), `${surface} does not expose ${name}`);
    }
}

const modernUi = read('views/default3.handlebars');
expect(!modernUi.includes('"MeshCentral"'), 'modern UI has no standalone MeshCentral product label');
expect(!modernUi.includes('MeshCentral Router'), 'modern UI brands the optional router download');
expect(modernUi.includes('Beacon Remote') && modernUi.includes('Beacon Agent') && modernUi.includes('Beacon Assistant'), 'modern UI contains all approved component names');

const core = read('agents/meshcore.js');
expect(!core.includes("var consentTitle = 'MeshCentral'"), 'agent consent fallback title is branded');
expect(!core.includes('var notifyTitle = "MeshCentral"'), 'agent notification fallback title is branded');
expect(core.includes("require('MeshAgent')"), 'internal upstream agent API identifier remains unchanged');
expect(read('meshcentral.js').includes("localname: 'MeshCentralAssistant.exe'"), 'internal upstream assistant artifact identifier remains unchanged');
const webserver = read('webserver.js');
expect(webserver.includes("'BeaconRemoteRouter.exe'"), 'router download filename is branded');
expect(!webserver.includes("setContentDispositionHeader(res, 'application/octet-stream', 'MeshCentralAssistant.exe'"), 'legacy assistant download filename is branded');

expect(exists('LICENSE'), 'Apache-2.0 license remains present');
expect(dockerfile.includes('org.opencontainers.image.licenses="Apache-2.0"'), 'image retains Apache-2.0 license metadata');

if (failures > 0) {
    console.error(`Phase 3.5 static validation failed with ${failures} issue(s).`);
    process.exit(1);
}
console.log('Phase 3.5 static validation passed.');
