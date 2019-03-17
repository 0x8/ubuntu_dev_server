# Ubuntu Dev Server Setup [Personal Twist]

> **Note**:  
> This branch is further tweaked to suit my own needs, it may or may not apply to
> you. Feel free to use this branch instead of the main branch. I will try my best
> to note the differences here.
>
> **Differences from Master**:
> - Adds Bootstrap Studio (License not included, obviously)
>   - Handles downloading from site
>   - Installs the .deb
>   - Creates a script /usr/bin/bstudio to launch it using dmenu
> - Sets up Jekyll:
>   - Gem installation
>   - Gem directory setup

This script exists to set up a minimal, graphical instance of Ubuntu Server (18.04)
that utilizes the i3-gaps desktop environment and the lightdm desktop manager. It
features a lot of the utilities and programs that I tend to use most often as well
as variations of my dotfiles tweaked for this particular use case.

While not everyone will use everything I download with this script, hopefully this
script helps someone out looking to quickly set up their system.
