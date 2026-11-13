# pmaports-troika – balíčky pro Motorola One Action (mainline kernel)

> **English in short:** the postmarketOS/Nura package set for the Motorola One
> Action (`troika`, Exynos 9609) on a mainline Linux 7.3.3 kernel. This is a
> clone of [pmaports](https://gitlab.postmarketos.org/postmarketOS/pmaports)
> with the device packages added on the branch `motorola-troika-mainline`.
> Documentation of the whole port (Czech): [nura-troika](https://github.com/letress/nura-troika).

Tento repozitář je kopie [pmaports](https://gitlab.postmarketos.org/postmarketOS/pmaports)
s balíčky pro **Motorola One Action** (`troika`) navrch. Celý projekt, jeho
stav, dokumentace a nástroje jsou v repozitáři
**[letress/nura-troika](https://github.com/letress/nura-troika)** – začni tam
([`PROGRESS.md`](https://github.com/letress/nura-troika/blob/main/PROGRESS.md),
[`TESTING.md`](https://github.com/letress/nura-troika/blob/main/TESTING.md)).

**Stav: rozpracováno, experimentální.** Balíčky se sestavují a výsledný
systém běží na telefonu (Phosh s Panfrost, WiFi, teploty); nejsou určené pro
běžné používání. Bez úplné zálohy telefonu nic nezkoušej a nikdy do něj
nenahrávej (`fastboot flash`); zkouší se jen přes `fastboot boot`.

## Balíčky

Všechny jsou v `device/testing/`:

| Balíček | Co dělá |
|---|---|
| `device-motorola-troika` | informace o zařízení (`deviceinfo`), device tree výrobce pro bootloader, pojistka proti zápisu na UFS v initramfs, načtení WiFi a nastavení adresy MAC, nastavení Phoshe (měřítko, podsvícení) |
| `linux-motorola-troika-mainline` | kernel 7.3.3 + patche (nastavení v `config-…`), uniLoader s kernelem a device tree, ovladač WiFi Samsung SCSC sestavovaný jako moduly (zdroje v `scsc-wlbt-troika.tar.gz`) |
| `firmware-motorola-troika` | modul firmwaru ACPM (frekvence a napětí) a firmware rádia WiFi; proprietární soubory výrobce stažené z veřejných zdrojů, přidává je do initramfs |

Patche kernelu se do balíčku zapisují skriptem `tools/update-kernel-pkg.sh`
z repozitáře [nura-troika](https://github.com/letress/nura-troika)
(zdroj pravdy je tam, adresář `kernel-patches/`).

## Sestavení

Potřebuješ [pmbootstrap](https://wiki.postmarketos.org/wiki/Pmbootstrap)
nastavený na tuto kopii pmaports (`-p /cesta/k/pmaports-troika`) a zařízení
`motorola-troika`:

```sh
pmbootstrap -p ~/pmaports-troika build --arch aarch64 linux-motorola-troika-mainline
pmbootstrap -p ~/pmaports-troika build --arch aarch64 firmware-motorola-troika
pmbootstrap -p ~/pmaports-troika build --arch aarch64 device-motorola-troika
pmbootstrap -p ~/pmaports-troika install
pmbootstrap -p ~/pmaports-troika export
```

Kernel se překládá asi hodinu a půl. Výsledný `boot.img` se **nenahrává**,
spouští se přes `fastboot boot` a systém běží přes `pmbootstrap netboot serve`
(telefon ho čte po USB). Přesný postup a kontroly po sestavení jsou v
[`TESTING.md`](https://github.com/letress/nura-troika/blob/main/TESTING.md).

## Větve a upstream

Výchozí větev `motorola-troika-mainline` = upstream pmaports + naše commity
navrch (adresář `device/testing/*troika*`). Zbytek stromu je beze změny a
řídí se licencemi postmarketOS.

## Licence

Balíčky v `device/testing/*troika*` vycházejí z postmarketOS (`MIT` a
`GPL-2.0-only` podle jednotlivých APKBUILD). Firmware výrobce
(`firmware-motorola-troika`) je označený `proprietary` a v repozitáři není;
balíček ho stahuje z veřejných zdrojů a ověřuje kontrolním součtem.
