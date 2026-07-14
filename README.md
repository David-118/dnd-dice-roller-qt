# Dnd Dice Roller (QT)
A Dnd Dice rolling application built for the Plasma Desktop Enviroment, written using the [Tyche Rust Libary](https://github.com/Gawdl3y/tyche-rs).
You can use it on any desktop enviroment but if you use COSMIC™ you might be more intered in [DnD Dice Roller](https://codeberg.org/Friedrich/dnd-dice-roller).

## Build
### Fedora 44
Install build dependcies

```bash
sudo dnf install qt6-qtbase-devel qt6-qtdeclarative-devel qt6-qtquickcontrols2-devel
sudo dnf install qt6-qtbase-private-devel
sudo dnf install rustup
```

If you have not setup your rust tool chain run

```bash
rustup-init
```

The deafult setup should work fine.

Build the project with cargo

```bash
cargo build -r
```

The executable with be located in `target/release/dnd_dice_qt`

### Any other platform
I have not tried building on other platforms if you run into any issues refered to the Getting started section for [qtbridge-rust](https://github.com/qt/qtbridge-rust).

While I don't know of any reasons this project would not run on other enviroments I have not personally tested it on any other platforms.
