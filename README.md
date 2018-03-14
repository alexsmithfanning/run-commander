# run-commander

This is a custom, portable, extensible, and feature-rich `.bashrc` that combines many incredible features into one file.

Currently planned features:
- [x] Automatic `bash-it` integration
- [x] `ntfy` integration for notifications
- [x] Support for `hstr`
- [x] `thefuck` integration
- [x] Intuitive support for coloring output

## Automatic integration

This `.bashrc` **automatically** integrates with programs it supports. Have `bash-it`? It's ready for that. `ntfy`? Ready for that too; right out of the box. Don't have any of these? That's fine, it just won't use it. No messing about disabling things yourself that you don't want enabled or don't have.

## Colored output

I always hated looking up how to do a certain color. With this, it sets variables to human-readable color names and associates it with their correct value.

Normally you'd have to type out the color code yourself. So, to output text in purple, you'd do this:
```bash
printf "\e[38;5;93mThis text is purple.\n"
```

But, with the color aliases, it becomes much easier and so much more readable:

```bash
printf "${PURPLE}This text is purple.${STANDARD}\n"
```