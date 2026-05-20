#!/bin/bash
# Manual deploy script for contact-form-react client extension.
#
# What this does:
#   1. Detects the actual hashed filenames from build/static/
#   2. Writes a concrete client-extension.yaml (no wildcards) into the
#      extension directory — Liferay cannot glob-resolve wildcard URLs
#      unless the Gradle plugin does it; we do it manually here instead.
#   3. Copies static assets alongside the yaml.
#
# Usage:
#   npm run build     (always build first)
#   npm run deploy    (or: sh deploy.sh)

set -e

CX_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_STATIC="$CX_DIR/build/static"
DEPLOY_DIR="/Users/goblingift/Development/liferay/client-extensions"
EXTENSION_DIR="$DEPLOY_DIR/contact-form-react"

# ---- pre-flight checks ----

if [ ! -d "$BUILD_STATIC" ]; then
  echo "ERROR: $BUILD_STATIC not found."
  echo "       Run 'npm run build' first."
  exit 1
fi

if [ ! -d "$DEPLOY_DIR" ]; then
  echo "ERROR: Deploy directory not found: $DEPLOY_DIR"
  echo "       Is Liferay accessible via the shared volume?"
  exit 1
fi

# ---- detect actual hashed filenames ----

JS_FILE=$(ls "$BUILD_STATIC"/*.js  2>/dev/null | head -1 | xargs basename)
CSS_FILE=$(ls "$BUILD_STATIC"/*.css 2>/dev/null | head -1 | xargs basename)

if [ -z "$JS_FILE" ]; then
  echo "ERROR: No .js file found in $BUILD_STATIC"
  echo "       Run 'npm run build' first."
  exit 1
fi

echo "Detected JS:  $JS_FILE"
echo "Detected CSS: ${CSS_FILE:-none}"

# ---- write extension directory ----

echo "Removing previous deployment..."
rm -rf "$EXTENSION_DIR"
mkdir -p "$EXTENSION_DIR/static"

echo "Copying static assets..."
cp -r "$BUILD_STATIC/"* "$EXTENSION_DIR/static/"

# Write a concrete client-extension.yaml with exact filenames.
# Liferay 7.4 does not resolve wildcard URL patterns (index.*.js) unless
# the Liferay Gradle plugin substitutes them — so we do it here instead.
echo "Writing client-extension.yaml with resolved filenames..."

if [ -n "$CSS_FILE" ]; then
  CSS_BLOCK="    cssURLs:
        - $CSS_FILE"
else
  CSS_BLOCK=""
fi

cat > "$EXTENSION_DIR/client-extension.yaml" << EOF
contact-form-react:
$CSS_BLOCK
    friendlyURLMapping: contact-form-react
    htmlElementName: contact-form-react
    instanceable: true
    name: Contact Form React
    portletCategoryName: category.remote-apps
    type: customElement
    urls:
        - $JS_FILE
    useESM: false
EOF

# ---- summary ----

echo ""
echo "Deployed to: $EXTENSION_DIR"
echo ""
echo "Structure:"
find "$EXTENSION_DIR" -type f | sed "s|$DEPLOY_DIR/||"
echo ""
echo "client-extension.yaml contents:"
cat "$EXTENSION_DIR/client-extension.yaml"
echo ""
echo "Restart Liferay (or wait for hot-reload) then watch for:"
echo "  STARTED contact-form-react"
