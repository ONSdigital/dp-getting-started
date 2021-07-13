Set up MacBook for development work
====

This document is part of the [Getting Started](https://github.com/ONSdigital/dp/blob/main/guides/GETTING_STARTED.md) guide.

Install Applications
----

1. (Strongly recommended) Install [homebrew](https://brew.sh/)

    - a macOS package manager - useful for installing (and keeping up-to-date) apps and utilities on macOS

2. (Optional) Install [iTerm2](https://www.iterm2.com/downloads.html) (or your terminal of choice).

    - used for the [command-line](https://en.wikipedia.org/wiki/Command-line_interface) (a good proportion of our work)

    - either install from the above website, or use `brew` to install:

      ```sh
      $ brew install --cask iterm2
      ```
    - the `$` in the example commands represents your shell prompt (`$` is for `bash`, but you might see `%` if using `zsh`) and is not typed

3. Install your preferred browser(s)

    - the team typically uses some combination of [Chrome](https://www.google.co.uk/chrome) and [Firefox](https://www.mozilla.org/en-GB/firefox)
    - the choice is yours
    - either install from the above websites, or use `brew` to install:

      ```sh
      $ brew install --cask google-chrome
      ```

      ```sh
      $ brew install --cask firefox
      ```
    
4. Install [Slack](https://slack.com/intl/en-gb/downloads/mac?geocode=en-gb)

    - the primary communication app (text, voice, video, screen-sharing) within the team/department (and beyond)
    - as usual, choose the above download link, or use `brew`:
      ```sh
      $ brew install --cask slack
      ```

5. (Recommended) Install [Visual Studio Code](https://code.visualstudio.com/docs/setup/mac)

    - an [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment) / graphical file editor
    - has many extensions for most file types and can do `go` debugging
    - if using `brew` for apps:
      ```sh
      $ brew install --cask visual-studio-code
      ```

6. (Recommended) MAC Software Update

    - In top left corner, Click `Apple Icon`, Click `About This Mac`, Click `Software Update...`

7. Trello

    - the primary Project Organizer within the team/department
    - you can install it via the App Store, OR access it via your browser

8. (Optional / Recommended) ZSH  ... the Z shell
    - this is an extended version of the `bash` shell
    - if using `brew` for apps:
      ```sh
      $ brew install zsh
      $ sudo nano /etc/shells
      ```
      Add the following to the end of the list and save the file:
      ```sh
      /usr/local/bin/zsh
      ```
      Use ```chsh``` to change the Shell line to be: `Shell: /usr/local/bin/zsh`. Save your changes and exit.
       
      and close/re-open terminal.

      (optional / Recommended) add `Oh My Zsh` with:
      ```sh
      % sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
      ```
      then to further customize, refer to Step 5 onwards, in:
      ```
      https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/
      ```

The MacBook is yours to configure in whatever way will help you be the most productive and comfortable. Feel free to install other software you find useful, like password managers, music players, note-taking apps.

Return to the [Getting Started](https://github.com/ONSdigital/dp/blob/main/guides/GETTING_STARTED.md) guide for next steps.

--------------

Git account and configuration
----

We use [git](https://book.git-scm.com/) for version control manangement (code and documentation). You will need an up-to-date version of `git`, we recommend running:

```sh
$ brew install git
```

Our code - in git repositories - is shared via [Github](https://github.com), so you'll need a Github account. You may use an existing account or set one up that is specific to ONS, if you like.

1. Create a [github account](https://github.com/), if you don't already have one.

2. Give your Github username to a Tech Lead, so that they can add you to the [ONSdigital](https://github.com/ONSdigital) organisation on Github.

3. Ensure you have [enabled Multi-Factor Authentication](https://docs.github.com/en/github/authenticating-to-github/configuring-two-factor-authentication) on your Github account.

4. Configure `git` locally by running the following commands:
  * `$ git config --global user.name "<YOUR_NAME>"`
  * `$ git config --global user.email <YOUR_EMAIL_IN_GITHUB>`

---


Making `git` work over `SSH`
---

In your home directory, run these commands:

  * `$ ssh-keygen` and write down the passphrase you enter (somewhere _very_ safe)

  * `$ cat ~/.ssh/id_rsa.pub`

Copy the displayed public key to your clipboard.

Then follow [instructions to add the SSH key in the clipboard to your github account](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)

Return to the [Getting Started](https://github.com/ONSdigital/dp/blob/main/guides/GETTING_STARTED.md) guide for next steps.

### Testing SSH Connection

To check that you've set up your Git SSH on your terminal, open your favoured terminal and enter:
  * `ssh -T git@github.com`
  
You will be asked to type *yes* if you're ready to connect. You should be prompted with:
  * `Hi [YOUR GIT USERNAME]! You've successfully authenticated, but GitHub does not provide shell access.`

You can then close your terminal. If it's unsuccessful check you've used the correct email address (email used for Github account) when creating and saving your key.

### Background

SSH (secure shell) is an encryption system for network communications (usually between client-server).

> Contrast with GPG (GNU Privacy Guard): an encryption system for encrypting files.

To protect sensitive data, both SSH and GPG use [cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography):
- **encryption** to protect sensitive data, where that data is either:
  - _in transit,_ in the case of `ssh` (over a network connection)
  - or, _at-rest,_ in the case of `gpg` (secure a file on a disc)

- **authentication** to prove the provenance of the data
  - when logging into a server using `ssh` - your ssh key proves that you are who you claim to be
  - when sending someone a document, GPG can be used to digitally sign that document to prove that it comes from you

In all cases, the receiver of the data must already have your **public key**. So:
- we give our ssh public keys
  - to servers that we wish to login to
  - to our github settings, so that we can authenticate to github (e.g. `git push`)
- we give our GPG public keys
  - to systems (e.g. github) that read files we wish to sign (e.g. git commits are effectively files, which we sign) to prove that they came from us
  - to colleagues, so that they may send us files securely

In DP, we use `ssh` to login to remote machines (including our servers in the cloud), and also to secure
our communication with Github.
