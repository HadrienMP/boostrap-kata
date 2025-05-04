# Commands

## test

```sh
mask format
for file in ./tests/**.sh
do
  echo -e "\n----------------"
  echo $file
  echo "----------------"
  ./"$file"
done
```

### test watch

```sh
watchexec -d 1 --clear -- $MASK test
```

### test coverage

```sh
kcov \
  --clean \
  --include-path=./src/ \
  --dump-summary \
  ./coverage/ \
  shunit2 ./tests/**.sh
```

## lint

```sh
shellcheck --format=diff ./**/**.sh | git apply --allow-empty
```

## format

```sh
shfmt --write ./**/**.sh
```

## run

OPTIONS

-   NAME
    -   flags: --name
    -   type: string

```sh
sh ./src/main.sh "$NAME"
```

## update

```bash
set -o errexit -o nounset -o pipefail -o errtrace

nix flake update
direnv exec . \
    devbox update
```

---

<!-- markdownlint-disable-next-line MD045 -->

This folder has been setup from the [`nix-sandboxes`'s template ![](https://img.shields.io/gitlab/stars/pinage404/nix-sandboxes?style=social)](https://gitlab.com/pinage404/nix-sandboxes)
