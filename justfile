tag := `date -u +%s`
image := "myprojectvariant:" + tag

# These ensure the built binary will work in the alpine container
buildenv := "GOOS=linux GARCH=amd64 CGO_ENABLED=0"

build:
    cd ../custom-action-demo-code && {{buildenv}} go build -o myprojectvariant cmd/myprojectvariant/main.go
    cd ../custom-action-demo-code && docker build -f ./cmd/myprojectvariant/Dockerfile . -t "{{image}}"

updateaction:
    sed -i 's|^  image:.*$|  image: "docker://{{image}}"|' action.yaml

test: build updateaction
    # --pull=false explanation:
    # https://github.com/nektos/act/issues/1594#issuecomment-1413067760
    act -j test --pull=false
