# docker-keyfinder-cli

WARNING: This gives different results than KeyFinder GUI application.
See [this issue](https://github.com/mixxxdj/libkeyfinder/issues/33).

## Usage

```
docker build -t turian/keyfinder-cli .
```

```
# Note that you want to use mp3s
docker run --rm -v $(pwd):/audio turian/keyfinder-cli test-files/Cm.mp3
```
You will see, unfortunately, that it outputs `Gm`. :(
