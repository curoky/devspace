#!/usr/bin/env python3

import argparse
import logging
import os
import platform
import shutil
import subprocess
from pathlib import Path


def ldd(binary: Path) -> list[Path]:
    logging.debug("cmd: ldd %s", binary)
    ldd_output = subprocess.check_output(["ldd", binary.as_posix()]).decode("utf-8")
    logging.debug("cmd:output: %s", ldd_output)
    deps = []
    for line in ldd_output.split("\n"):
        if "=>" in line:
            deps.append(Path(line.split("=>")[1].strip().split(" ")[0]))
    return deps


def otool(binary: Path) -> list[Path]:
    logging.debug("cmd: otool -L %s", binary)
    otool_output = subprocess.check_output(["otool", "-L", binary.as_posix()]).decode(
        "utf-8"
    )
    logging.debug("cmd:output: %s", otool_output)
    deps = []
    for line in otool_output.split("\n")[1:]:
        # Skip the first line which is the binary itself
        if line.strip():  # Ensure the line is not empty
            dep = Path(line.split(" ")[0].strip())

            if dep.parent.name == "@rpath":
                dep = binary.parent / dep.name

            # skip on dep is self
            if dep == binary:
                continue

            # skip on system lib
            if dep.as_posix().startswith("/usr/lib"):
                continue

            deps.append(dep)
    return deps


class install_name_tool:
    @staticmethod
    def change(binary: Path, src: Path, dst: Path):
        logging.debug("cmd: install_name_tool -change %s %s %s", src, dst, binary)
        output = subprocess.check_output(
            [
                "install_name_tool",
                "-change",
                src.as_posix(),
                dst.as_posix(),
                binary.as_posix(),
            ]
        )
        logging.debug("cmd:output: %s", output)

    @staticmethod
    def add_rpath(binary: Path, rpath: Path):
        logging.debug("cmd: install_name_tool -add_rpath %s %s ", rpath, binary)
        output = subprocess.check_output(
            ["install_name_tool", "-add_rpath", rpath.as_posix(), binary.as_posix()]
        )
        logging.debug("cmd:output: %s", output)


def patchelf_set_rpath(binary: Path, rpaths: list[Path]) -> None:
    for rpath in rpaths:
        logging.debug(
            "cmd: patchelf --set-rpath %s %s", rpath.as_posix(), binary.as_posix()
        )
        output = subprocess.check_output(
            ["patchelf", "--set-rpath", rpath.as_posix(), binary.as_posix()]
        )
        logging.debug("cmd:output: %s", output)


def is_macos():
    system = platform.system()
    return system == "Darwin"


def resolve_deps(binary: Path):
    # a.so -> b.so
    #      -> c.so
    #             -> e.so
    #             -> f.so
    #             -> b.so
    #      -> d.so

    edge: dict[Path, list[Path]] = dict()
    total_deps: set[Path] = set()

    def recursive(binary: Path):
        logging.debug("reslove:recursive: on %s", binary)

        if binary in edge:
            logging.debug("reslove:recursive: skip %s", binary)
            return

        deps = otool(binary) if is_macos() else ldd(binary)
        logging.debug("reslove:recursive: deps is %s", deps)
        edge[binary] = deps

        if len(deps) <= 0:
            return
        for dep in deps:
            total_deps.add(dep)
            recursive(dep)

    recursive(binary)

    return edge, total_deps


def patch_deps(binary: Path, edge: dict[Path, list[Path]], bundle_path: Path):
    logging.info("start patch_deps %s to %s with (%s)", binary, bundle_path, edge)
    processed = set()

    def recursive(binary: Path):
        if binary not in edge or binary in processed:
            return
        install_name_tool.add_rpath(binary, bundle_path)
        processed.add(binary)
        if is_macos():
            for dep in edge[binary]:
                recursive(binary)
                install_name_tool.change(binary, dep, bundle_path / dep.name)

    recursive(binary)


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument("binary_source_path", type=Path, help="")
    parser.add_argument("binary_save_path", type=Path, help="")
    parser.add_argument("bundle_path", type=Path, help="")

    args = parser.parse_args()
    binary_source_path = args.binary_source_path.resolve()
    binary_save_path = args.binary_save_path.resolve()
    bundle_path = args.bundle_path.resolve()

    logging.info("binary_source_path: %s", binary_source_path)
    logging.info("binary_save_path: %s", binary_save_path)
    logging.info("bundle_path: %s", bundle_path)

    os.makedirs(bundle_path.as_posix(), exist_ok=True)

    edge, total_deps = resolve_deps(binary_source_path)
    edge[binary_save_path] = edge[binary_source_path]
    logging.debug("after resolve_deps, edge: %s, totoal_deps: %s", edge, total_deps)

    for dep in total_deps:
        logging.debug("copy %s -> %s", dep, bundle_path)
        shutil.copy(
            src=dep.as_posix(), dst=bundle_path.as_posix(), follow_symlinks=True
        )

    if binary_save_path != binary_source_path:
        logging.debug("copy %s -> %s", binary_source_path, binary_save_path)
        shutil.copy(src=binary_source_path, dst=binary_save_path, follow_symlinks=True)

    if is_macos():
        patch_deps(binary_save_path, edge, bundle_path)
    else:
        patchelf_set_rpath(binary_save_path, [bundle_path])


if __name__ == "__main__":
    logging.basicConfig(format="%(levelname)s:%(message)s", level=logging.DEBUG)
    main()
