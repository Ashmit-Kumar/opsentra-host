# Log Collector Service

This is a simple Linux service that collects logs from various system log files (syslog, auth.log, daemon.log, debug, kern.log, Xorg.0.log) and prints them to stdout with prefixes (which goes to systemd journal).

## Building the RPM Package

1. Transfer the files to a Linux system (Red Hat-based, like CentOS, Fedora, RHEL) with `rpmbuild` installed.

2. Run the build script:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

3. The RPM will be created in `~/rpmbuild/RPMS/`.

## Installing the RPM

On the target Linux system:
```bash
sudo rpm -i log-collector-1.0-1.el8.x86_64.rpm  # Adjust filename as needed
```

Or install directly from GitHub Pages (after CI publishes the RPM to gh-pages):

```bash
# Example: replace USER/REPO and FILENAME with real values
sudo yum localinstall -y https://USER.github.io/REPO/log-collector-1.0-1.noarch.rpm
```

## Managing the Service

- Start: `sudo systemctl start log-collector`
- Stop: `sudo systemctl stop log-collector`
- Status: `sudo systemctl status log-collector`
- Enable on boot: `sudo systemctl enable log-collector`

## Logs

The service logs are collected by systemd. View with:
```bash
journalctl -u log-collector
```

## Note

This is a basic implementation. In production, you might want to:
- Send logs to a central server
- Handle more log files or dynamic discovery
- Add configuration options
- Improve error handling

**Permissions:** The service runs as root to access system log files in `/var/log/`. Ensure the service account has appropriate permissions if modifying the user.

Since Ubuntu uses DEB packages, if you need DEB instead of RPM, you can convert using `alien` or create a DEB package structure.