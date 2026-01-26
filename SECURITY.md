# Security Policy

## Supported Versions

We are currently supporting the following versions with security updates. We recommend all users stay on the latest stable release.

| Version | Supported |
| --- | --- |
| 1.0.x | :white_check_mark: |
| < 1.0 | :x: |

## Reporting a Vulnerability

If you discover a security vulnerability within Bimagic, please do not use the public GitHub issue tracker. Instead, follow these steps:

1. **Email the Maintainers**: Send a detailed report to the email associated with the **Bimbok** or **adityapaul26** GitHub profiles.
2. **Provide Details**: Include a description of the vulnerability, steps to reproduce the issue, and the potential impact.
3. **Response Time**: You can expect an acknowledgment of your report within 48–72 hours.
4. **Public Disclosure**: We ask that you do not disclose the vulnerability publicly until we have had the opportunity to analyze and fix the issue to protect our users.

## Security Best Practices for Bimagic

* **Token Safety**: Your `GITHUB_TOKEN` is stored in your shell configuration (e.g., `.bashrc` or `.zshrc`). Ensure these files are not readable by other users on your system (run `chmod 600 ~/.bashrc`).
* **Dependencies**: Bimagic relies on `gum` for its interface. Always ensure your system's package manager is up to date to receive security patches for dependencies.
* **Sudo Usage**: The installation script only requires `sudo` if installing to system-wide directories like `/usr/local/bin`. For maximum security, consider installing to `~/bin` to avoid using elevated privileges.
