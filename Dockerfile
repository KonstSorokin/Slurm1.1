# Start by building the application.
FROM golang:1.19-alpine as build
 
WORKDIR /go/src/app
COPY . .
 
RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/app.bin cmd/main.go
 
FROM scratch
USER nobody
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group
WORKDIR /upload
VOLUME [ "/upload" ]
COPY --from=build --chown=nobody:nobody /go/bin/app.bin /upload/app.bin
COPY --from=build --chown=nobody:nobody /go/src/app/upload /upload/uploads
ENTRYPOINT ["/upload/app.bin"]
