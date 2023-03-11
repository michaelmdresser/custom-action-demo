tag := `date -u +%s`
image := "myprojectvariant:" + tag

# These ensure the built binary will work in the alpine container
buildenv := "GOOS=linux GARCH=amd64 CGO_ENABLED=0"

build:
    cd ../custom-action-docker-testing && {{buildenv}} go build -o myprojectvariant cmd/myprojectvariant/main.go
    cd ../custom-action-docker-testing && docker build -f ./cmd/myprojectvariant/Dockerfile . -t "{{image}}"

updateaction:
    sed -i 's|^  image:.*$|  image: "docker://{{image}}"|' action.yaml

test: build updateaction
    # --pull=false explanation:
    # https://github.com/nektos/act/issues/1594#issuecomment-1413067760
    ./bin/act -j test --pull=false
