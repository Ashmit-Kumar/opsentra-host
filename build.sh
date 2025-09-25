tar -czf ${NAME}-${VERSION}.tar.gz log_collector.py log-collector.service log-collector.spec
#!/bin/bash
set -euo pipefail
# Build script for log-collector RPM package
# Works locally on a Linux machine with rpmbuild installed, and in CI (Ubuntu).

NAME="log-collector"
VERSION="1.0"
SRCTAR="${NAME}-${VERSION}.tar.gz"

echo "Creating source tarball ${SRCTAR}..."
tar -czf "${SRCTAR}" log_collector.py log-collector.service log-collector.spec

RPMBUILD_DIR="${HOME}/rpmbuild"
echo "Setting up rpmbuild dirs under ${RPMBUILD_DIR}..."
mkdir -p "${RPMBUILD_DIR}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

echo "Copying sources and spec..."
cp "${SRCTAR}" "${RPMBUILD_DIR}/SOURCES/"
cp log-collector.spec "${RPMBUILD_DIR}/SPECS/"

echo "Building RPM..."
rpmbuild -ba "${RPMBUILD_DIR}/SPECS/log-collector.spec"

# Locate the built RPM
RPM_OUTPUT=$(find "${RPMBUILD_DIR}/RPMS" -type f -name "${NAME}-*.rpm" | head -n1 || true)
if [ -z "${RPM_OUTPUT}" ]; then
	echo "ERROR: RPM not found in ${RPMBUILD_DIR}/RPMS"
	exit 1
fi

mkdir -p dist
cp "${RPM_OUTPUT}" dist/

echo "Built RPM: ${RPM_OUTPUT}"
echo "Copied RPM to dist/"

# Create a local gh-pages/ folder (optional) so it can be inspected or published
mkdir -p gh-pages
cp dist/*.rpm gh-pages/ || true

cat > gh-pages/index.html <<'EOF'
<!doctype html>
<html>
	<head>
		<meta charset="utf-8">
		<title>log-collector downloads</title>
	</head>
	<body>
		<h1>log-collector RPMs</h1>
		<ul>
EOF

for f in gh-pages/*.rpm; do
	[ -e "$f" ] || continue
	filename=$(basename "$f")
	echo "      <li><a href=\"${filename}\">${filename}</a></li>" >> gh-pages/index.html
done

cat >> gh-pages/index.html <<'EOF'
		</ul>
	</body>
</html>
EOF

echo "Created gh-pages/ with index.html. To publish, push the gh-pages directory to the gh-pages branch (CI does this automatically)."