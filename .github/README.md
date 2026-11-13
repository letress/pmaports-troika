# pmaports-troika – packages for the Motorola One Action (mainline kernel)

The postmarketOS/Nura package set for the **Motorola One Action** (`troika`,
Exynos 9609) on a mainline Linux 7.3.3 kernel. This repository is a copy of
[pmaports](https://gitlab.postmarketos.org/postmarketOS/pmaports) with the
device packages added on top. The whole project, its status, documentation and
tools live in
**[letress/nura-troika](https://github.com/letress/nura-troika)** – start there
([`PROGRESS.md`](https://github.com/letress/nura-troika/blob/main/PROGRESS.md),
[`TESTING.md`](https://github.com/letress/nura-troika/blob/main/TESTING.md)).
The documentation there is in Czech.

**Status: work in progress, experimental.** The packages build and the
resulting system runs on the phone (Phosh with Panfrost, Wi-Fi, temperatures);
they are not meant for everyday use. Do not try anything without a full backup
of the phone, and never flash it (`fastboot flash`); test only with
`fastboot boot`.

## Packages

All are in `device/testing/`:

| Package | What it does |
|---|---|
| `device-motorola-troika` | device info (`deviceinfo`), the vendor device tree for the bootloader, a write guard for UFS in the initramfs, Wi-Fi module loading and MAC address setup, Phosh settings (scaling, backlight) |
| `linux-motorola-troika-mainline` | kernel 7.3.3 + patches (configuration in `config-…`), uniLoader with the kernel and device tree, the Samsung SCSC Wi-Fi driver built as modules (sources in `scsc-wlbt-troika.tar.gz`) |
| `firmware-motorola-troika` | ACPM firmware module (frequencies and voltages) and Wi-Fi radio firmware; proprietary vendor files downloaded from public sources and added to the initramfs |

The kernel patches are written into the package by `tools/update-kernel-pkg.sh`
from the [nura-troika](https://github.com/letress/nura-troika) repository (the
source of truth is its `kernel-patches/` directory).

## Building

You need [pmbootstrap](https://wiki.postmarketos.org/wiki/Pmbootstrap) pointed
at this copy of pmaports (`-p /path/to/pmaports-troika`) and the device
`motorola-troika`:

```sh
pmbootstrap -p ~/pmaports-troika build --arch aarch64 linux-motorola-troika-mainline
pmbootstrap -p ~/pmaports-troika build --arch aarch64 firmware-motorola-troika
pmbootstrap -p ~/pmaports-troika build --arch aarch64 device-motorola-troika
pmbootstrap -p ~/pmaports-troika install
pmbootstrap -p ~/pmaports-troika export
```

The kernel takes about an hour and a half to compile. The resulting `boot.img`
is **not flashed**; it is started with `fastboot boot` and the system runs
through `pmbootstrap netboot serve` (the phone reads it over USB). The exact
procedure and post-build checks are in
[`TESTING.md`](https://github.com/letress/nura-troika/blob/main/TESTING.md).

## Branches and upstream

The default branch `motorola-troika-mainline` = upstream pmaports + our commits
on top (the `device/testing/*troika*` directories). The rest of the tree is
unchanged and follows the postmarketOS licenses.

## License

The packages in `device/testing/*troika*` are derived from postmarketOS (`MIT`
and `GPL-2.0-only` according to each APKBUILD). The vendor firmware
(`firmware-motorola-troika`) is marked `proprietary` and is not in the
repository; the package downloads it from public sources and verifies it with a
checksum.
