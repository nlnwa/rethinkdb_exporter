FROM golang:alpine as builder

ENV GO111MODULE=on

RUN apk add --no-cache --update git

COPY go.mod go.sum /go/src/github.com/nlnwa/rethinkdb_exporter/

RUN cd src/github.com/nlnwa/rethinkdb_exporter && go mod download

COPY . ./src/github.com/nlnwa/rethinkdb_exporter

RUN cd src/github.com/nlnwa/rethinkdb_exporter && CGO_ENABLED=0 GOOS=linux go build


FROM scratch

LABEL maintaner="Marius André Elsfjordstrand Beck <marius.beck@nb.no>"

COPY --from=builder /go/src/github.com/nlnwa/rethinkdb_exporter/rethinkdb_exporter /

EXPOSE     9123
ENTRYPOINT [ "/rethinkdb_exporter" ]
