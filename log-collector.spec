Name:           log-collector
Version:        1.0
Release:        1%{?dist}
Summary:        A simple log collector service for Linux

License:        MIT
URL:            https://github.com/Ashmit-Kumar/opsentra-host
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

%description
This package installs a systemd service and a small Python script that tails common system logs and writes them to stdout (captured by systemd journal).

%prep
%setup -q

%build
# No build step required

%install
mkdir -p %{buildroot}/opt/%{name}
install -m 755 log_collector.py %{buildroot}/opt/%{name}/log_collector.py
mkdir -p %{buildroot}/usr/lib/systemd/system/
install -m 644 log-collector.service %{buildroot}/usr/lib/systemd/system/log-collector.service

%files
%dir /opt/%{name}
/opt/%{name}/log_collector.py
/usr/lib/systemd/system/log-collector.service

%post
# Reload systemd units and enable/start the service
%systemd_post log-collector.service

%preun
%systemd_preun log-collector.service

%postun
%systemd_postun_with_restart log-collector.service

%changelog
* Thu Sep 25 2025 Your Name ashmitkumar1020@gmail.com - 1.0-1
- Initial package