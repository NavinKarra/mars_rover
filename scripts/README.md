# Sample Customer Launcher

This sample downloads and runs a prebuilt Mars Rover executable from a **public**
GitHub Release. Customers need no GitHub account, Git, CMake, or compiler. It uses
the shell, curl, and standard macOS/Linux utilities, including a SHA-256 tool.
Windows needs a separate PowerShell launcher.

## Try It

After publishing compatible release assets, run from the project directory:

```sh
sh scripts/run-rover.sh
```

The script defaults to `NavinKarra/mars_rover`. Send the configured script once;
customers can run it with `sh run-rover.sh` without setting any variables.
Application arguments are forwarded unchanged. Developers can override the
repository with `MARS_ROVER_REPOSITORY` for testing or a different release source.

The default installation directory is `$HOME/.local/share/mars-rover`.
`MARS_ROVER_INSTALL_DIR` overrides it. No administrator access is needed.
Each launch downloads and verifies the latest binary; identical binaries are not
reinstalled. Updates do not run in the background. Failed downloads or checksum
checks leave the installed executable untouched, so it can still run offline.

## Release Contract

CI must build and test each supported OS/architecture, then attach raw executables
and checksum files to a stable GitHub Release. For example:

```text
mars-rover-darwin-arm64
mars-rover-darwin-arm64.sha256
mars-rover-linux-x86_64
mars-rover-linux-x86_64.sha256
```

Other supported names are `mars-rover-darwin-x86_64` and
`mars-rover-linux-arm64`, each with a matching `.sha256` file. The checksum file's
first line must start with the executable's lowercase SHA-256 hex digest.
Upload all assets before publishing the release. Never rename a binary built for
one platform to claim support for another. Package runtime dependencies as needed.

## Publish An Update

`.github/workflows/release.yml` builds and tests macOS ARM64, macOS x86-64, and
Linux x86-64 on version tags. It uploads the binaries and checksums to a draft
release, then publishes it only after every build succeeds. Linux ARM64 is not
built by this workflow.

First commit and push the workflow, launcher, and launcher tests. Then, from the
commit you want to release, create and push a new version tag:

```sh
git tag v0.1.0
git push origin v0.1.0
```

Use a new version tag for each update. Wait for **Publish Customer Release** in
GitHub Actions to finish before asking customers to run the launcher. GitHub
Actions must be enabled and permitted to write releases. A failed publishing job
can be rerun while its release remains a draft; published releases are not
overwritten. Tags in this workflow are treated as stable customer releases.

A 404 from the launcher means the expected asset is not publicly accessible.
Check that a stable release is published, that its assets match the customer's
platform, and that the repository is public. GitHub also returns 404 for private
resources without authentication. Creating a tag alone does not make assets
available until the workflow finishes.

The current executable is only a placeholder; this pipeline does not add a rover
user interface.

## Limitations

Checksums detect corrupted downloads, not a compromised publisher. Production
delivery should add publisher signature verification and applicable platform
signing/notarization. Do not embed private repository tokens in customer scripts.
This sample neither detects an application that fails after installation nor
rolls back such a failure. A forced shutdown may leave `.update-lock` behind;
remove that empty directory only after confirming no launcher is active.

Run the isolated launcher checks with `sh test/launcher_test.sh`.