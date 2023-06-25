# NES Tetris Hacks

These are various romhacks of the NES game Tetris.

Without any options, building this repo makes the following:

* Tetris (U) [!].nes `md5: ec58574d96bee8c8927884ae6e7a2508`

To set up the repository, see [**INSTALL.md**](INSTALL.md).

Multiple hacks are compatible unless otherwise noted, for example to build Penguin Line Clear with Anydas:

    build.sh -H anydas -H penguin


## Anydas

![Anydas](./assets/Anydas.png)

Credit to [HydrantDude](https://www.youtube.com/@hydrantdude3642)

Anydas skips the legal screen and provides a menu that allows for a customized Delayed Auto Shift (DAS) experience.  The DAS setting, presented in hexadecimal, controls the initial delay in number of frames.  The Auto Repeat Rate (ARR), also presented in hexadecimal, controls how many frames between shifts after the initial delay.   The ARE Charge setting when enabled allows the DAS charge to occur during entry delay.   

See [this page](https://tetris.fandom.com/wiki/ARE) for an explanation of ARE.

    build.sh -H anydas


## Penguin Line Clear

![PenguinLineClear](./assets/PenguinLineClear.gif)

The line clearing animation has been replaced with a penguin that clears the blocks for you.

    build.sh -H penguin


## Same Piece Sets

![SamePieceSets](./assets/SamePieceSets.png)

Credit to [Kirjava](https://kirjava.xyz/)

Provides an option to enter a seed value that determines the piece sequence.  100% compatible with [TetrisGYM](https://github.com/kirjavascript/TetrisGYM)

    build.sh -H sps


## Wallhack 2

![Wallhack2](./assets/Wallhack2.gif)

Provides a wraparound experience similar to the vertical levels of Super Mario Bros. 2.  

    build.sh -H wallhack2


## Thanks
[CelestialAmber](https://github.com/CelestialAmber/TetrisNESDisasm) Repo from which this is derived

[ejona86](https://github.com/ejona86/taus) Repo from which above repo is derived and info file

[qalle2](https://github.com/qalle2/nes-util) CHR tools

[kirjavascript](https://github.com/kirjavascript/TetrisGYM) borrowed bits

