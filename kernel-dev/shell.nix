{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "linux-kernel-build";
  targetPkgs = pkgs: (with pkgs;  [
    perl
    getopt
    flex
    bison
    # our binutils is currently too old (< 2.32) and breaks with our shipped elfutils
    # https://wiki.gentoo.org/wiki/Binutils_2.32_upgrade_notes/elfutils_0.175:_unable_to_initialize_decompress_status_for_section_.debug_info
    (elfutils.overrideAttrs (old: rec {
      pname = "elfutils";
      version = "0.174";
      name = "${pname}-${version}";
      src = fetchurl {
        url = "https://sourceware.org/elfutils/ftp/${version}/${pname}-${version}.tar.bz2";
        sha256 = "12nhr8zrw4sjzrvpf38vl55bq5nm05qkd7nq76as443f0xq7xwnd";
      };
      NIX_CFLAGS_COMPILE = "-Wno-error=missing-attributes";
    }))
    binutils
    ncurses.dev
    openssl.dev
    zlib.dev
    gcc
    gnumake
    bc
  ]);
  runScript = "bash";
}).env
