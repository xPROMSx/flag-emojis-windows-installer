# Attribution and font provenance

This repository is an installer-focused fork of [Chasmical/flag-emojis-for-windows](https://github.com/Chasmical/flag-emojis-for-windows). The original source code is licensed under the MIT License, whose copyright notice is preserved in [LICENSE](LICENSE).

The original project combines Microsoft Segoe UI Emoji with flag glyphs from [jdecked/twemoji](https://github.com/jdecked/twemoji). The original project's font compilation and artwork are **not** part of this installer's source tree. Removing upstream build tools and screenshots does not change the origin or rights of the resulting font.

**Important:** the MIT license for source code does not automatically grant permission to redistribute Microsoft's font components. The legal status of distributing or bundling the modified TTF must be reviewed before the installer is published. The implementation may download a pinned upstream asset rather than bundle it, but that alone does not settle the relevant license questions.

The fork's Git history and GitHub fork relationship preserve its origin. This document contains the necessary technical source attribution without links to personal blogs or unrelated promotional pages.


## Microsoft font licensing

[Microsoft's official Font redistribution FAQ](https://learn.microsoft.com/en-us/typography/fonts/font-faq) states that Windows-supplied fonts cannot generally be redistributed or modified under the standard Windows license. This applies to Segoe UI Emoji, including emoji fonts. The project's MIT license covers installer source code, not the proprietary Microsoft font.

This repository does **not** include, redistribute or build a modified TTF; the installer downloads a fixed, checksum-verified binary from an independent upstream project only on user request. This design does not grant permission to modify Microsoft's fonts or eliminate all potential legal concerns. Third-party font usage and licensing remain the responsibility of the relevant rights holders and users.
