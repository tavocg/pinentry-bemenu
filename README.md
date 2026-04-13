# pinentry-bemenu
This is a fork of [phenax/anypinentry](https://github.com/phenax/anypinentry),
with bemenu as backend.

pinentry-bemenu is a wrapper interface for gnupg's pinentry using bemenu for password and confirmation prompts.

> Note: This is NOT a complete replacement for pinentry programs but it should cover most use-cases. Report any issues you face so the program can be improved

## Dependencies
* sh
* bemenu
* notify-send (optional: for the default config only)

## Usage
1. Clone the repo to anywhere on your machine (you should maintain a fork in case you want to configure the default behavior)
2. Run `chmod +x ./pinentry-bemenu` inside the cloned directory
3. Edit the script file if you want to configure it. 
4. Edit `~/.gnupg/gpg-agent.conf` (or create it) and add the line `pinentry-program /<path-to-your-clone>/pinentry-bemenu`
5. Run `gpg-agent reload` to reload the config or logout and log back in
6. Gpg should now be using your preferred program for pinentry

## Config
The following variables inside the `./pinentry-bemenu` script can be configured.
You will need to use `AP_PROMPT`, `AP_YES`, `AP_NO`, `AP_ERROR` variables inside your actions.

* `prompt_action` - Action to show a prompt asking for password (Example with bemenu - `bemenu -x indicator -p "$AP_PROMPT"`)
* `confirm_action` - Action to confirm something (YES or NO) (Example with bemenu - `printf "%s\n%s" "$AP_YES" "$AP_NO" | bemenu -p "$AP_PROMPT"`)
* `display_error_action` - Action to display error messages to user (Example with notify-send - `notify-send "$AP_ERROR"`)
