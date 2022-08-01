REPO := "borsboom/utils"
PUSH_TAG := `date +%Y.%m.%d`

build:
    docker build -t {{ quote(REPO) }}:latest .

run: build
    docker run -ti --rm {{ quote(REPO) }}:latest

push: build
    docker tag {{ quote(REPO) }}:latest {{ quote(REPO) }}:{{ quote(PUSH_TAG) }}
    docker push {{ quote(REPO) }}:latest
    docker push {{ quote(REPO) }}:{{ quote(PUSH_TAG) }}
