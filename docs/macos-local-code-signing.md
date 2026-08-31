# Local code signing for macOS privacy permissions

## Why this is needed

macOS privacy permissions managed by TCC, including Full Disk Access and App
Management, are associated with an application's code identity. An ad-hoc
signature identifies one particular build by its code hash, so replacing the
executable can make macOS treat the next build as a different application.

This configuration installs these applications from Nix and then copies their
bundles into `~/Applications/Home Manager Apps`:

- Emacs is built from the `pkgs.emacs31` source package, with local patches and
  Emacs packages added by Home Manager.
- WezTerm is provided by `pkgs.wezterm` rather than by installing the upstream
  downloadable app bundle.
- MeetingBar is provided by `pkgs.meetingbar` and uses macOS Calendar access to
  read upcoming meetings.

The Nix store bundles used by this configuration have ad-hoc signatures and no
Team ID. There is therefore no upstream Developer ID signature in these
particular build outputs for Home Manager to preserve. Upstream downloadable
artifacts may be packaged differently, but they are not the artifacts selected
by this configuration.

The Home Manager activation hook in
`nix/home-manager/programs/macos/default.nix` signs only Emacs, WezTerm, and
MeetingBar with one persistent local certificate after the `copyApps`
activation step. Their bundle identifiers remain distinct, so macOS still
manages their permissions separately.

## Permissions used on this machine

| Application | Full Disk Access | App Management | Calendar |
| --- | --- | --- | --- |
| Emacs | yes | no | no |
| WezTerm | yes | yes | no |
| MeetingBar | no | no | yes |

The activation hook stabilizes application identity. It does not grant TCC
permissions; macOS still requires the initial grants to be made manually.

## Create the signing identity

Open Keychain Access using Spotlight, then select:

```text
Keychain Access > Certificate Assistant > Create a Certificate...
```

Use these values on the first page:

| Field | Value |
| --- | --- |
| Name | `Local App Code Signing` |
| Identity Type | `Self Signed Root` |
| Certificate Type | `Code Signing` |
| Let me override defaults | enabled |

Use the following values in the remaining pages:

- Serial number: `1`
- Validity period: `3650` days
- Key algorithm: RSA
- Key size: 2048 or 4096 bits
- Key usage and extensions: keep the Code Signing defaults
- Destination keychain: `login`

After creation, open the `login` keychain and select `My Certificates`. Expand
`Local App Code Signing` and confirm that a private key appears below it.

Check the identity from WezTerm:

```bash
security find-identity -v -p codesigning
```

The expected result includes:

```text
"Local App Code Signing"
1 valid identities found
```

If it reports no valid identities, open the certificate, expand **Trust**, and
set Code Signing to **Always Trust**. If macOS does not show a separate Code
Signing setting, set **When using this certificate** to **Always Trust**.

The certificate name is part of the local configuration contract. If it is
changed, update `signingIdentity` in
`nix/home-manager/programs/macos/default.nix` as well.

## Back up the identity

In Keychain Access, select `Local App Code Signing` under **My Certificates**.
Export it in Personal Information Exchange (`.p12`) format. Selecting the
identity rather than only the public certificate ensures that the private key
is included.

Use a unique, generated password for the `.p12` export and keep the file and
password in secure storage outside this public repository. Verify the backup
and its recovery path before deleting the local export. Do not commit the
`.p12`, its password, an encrypted copy, or details about the storage provider
to this repository.

## Apply the signatures

Quit Emacs and WezTerm, then apply the configuration:

```bash
make apply
```

The activation hook runs after Home Manager copies application bundles. It
signs these paths:

```text
~/Applications/Home Manager Apps/Emacs.app
~/Applications/Home Manager Apps/WezTerm.app
~/Applications/Home Manager Apps/MeetingBar.app
```

Confirm that both applications use a certificate-based designated requirement:

```bash
codesign -d -r- "$HOME/Applications/Home Manager Apps/Emacs.app"
codesign -d -r- "$HOME/Applications/Home Manager Apps/WezTerm.app"
codesign -d -r- "$HOME/Applications/Home Manager Apps/MeetingBar.app"
```

The identifiers should be `org.gnu.Emacs`, `com.github.wez.wezterm`, and
`leits.MeetingBar`, while the `certificate leaf` hash should be the same for
all three applications.

## Grant privacy permissions

Re-signing changes the applications from their old ad-hoc identities to their
new stable identities. Remove stale entries and add the newly signed bundles
once.

Open **System Settings > Privacy & Security > Full Disk Access** and add:

```text
~/Applications/Home Manager Apps/Emacs.app
~/Applications/Home Manager Apps/WezTerm.app
```

Open **System Settings > Privacy & Security > App Management** and add:

```text
~/Applications/Home Manager Apps/WezTerm.app
```

Open **System Settings > Privacy & Security > Calendars** and enable
MeetingBar. If MeetingBar is not listed yet, launch it and select the macOS
Calendar provider so that macOS presents the initial permission request.

Quit and reopen all three applications after changing the permissions. In
particular, completely quit and reopen WezTerm before running another
activation so that the active terminal process has the newly signed identity.

## Normal upgrades

No additional signing command is required. Both of the normal entry points run
the signing hook after copying updated application bundles:

```bash
make apply
make upgrade
```

Do not add vendor-signed applications such as browsers to the local signing
list. Re-signing them would replace their vendor identity and can interfere
with notarization, updates, helper relationships, and other security checks.

## Restore the identity

If the login keychain is lost:

1. Retrieve `Local-App-Code-Signing.p12` from the secure backup.
2. Open Keychain Access and choose **File > Import Items**.
3. Import the file into the `login` keychain using the password stored in the
   backup.
4. Confirm that the certificate and its private key appear under **My
   Certificates**.
5. Run `security find-identity -v -p codesigning`.
6. Quit Emacs, WezTerm, and MeetingBar, then run `make apply`.

Restoring the original `.p12` preserves the signing key. Creating another
certificate with the same display name does not: a new certificate has a new
key and certificate hash, so macOS treats it as a different signer.

On a new macOS installation, TCC permissions must still be granted manually,
even when the original signing identity has been restored.

## Troubleshooting

### The activation reports that the identity was not found

Run:

```bash
security find-identity -v -p codesigning
```

Confirm the exact name `Local App Code Signing`, the presence of its private
key, and its trust setting.

### A permission disappeared after signing was enabled

The old permission belongs to the previous ad-hoc identity. Remove the old
entry in System Settings, add the signed application again, and restart it.

### Home Manager cannot update application bundles

The terminal application running `make apply` needs App Management permission.
Grant it to the signed WezTerm bundle, completely restart WezTerm, and retry the
activation.
