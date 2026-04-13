FROM registry.access.redhat.com/ubi10/go-toolset@sha256:3712c9b5021efb3d0d92d72d84342fe8dce2783cdd9f286e87dff86165977b16 AS builder

WORKDIR /workspace

COPY --chmod=644 go.mod go.mod
COPY --chmod=644 go.sum go.sum
COPY --chmod=644 main.go main.go

RUN go mod download

RUN CGO_ENABLED=0 go build -o /opt/app-root/sample-component-golang main.go

FROM registry.access.redhat.com/ubi10/ubi-minimal@sha256:7bd3d2e7f5c507aebd1575d0f2fab9fe3e882e25fee54fa07f7970aa8bbc5fab

COPY --from=builder /opt/app-root/sample-component-golang /sample-component-golang

EXPOSE 8080
USER 65532:65532

LABEL name="Sample Component Golang"
LABEL description="Sample component written in Golang"
LABEL summary="Sample component written in Golang"
LABEL io.k8s.description="Sample component written in Golang"
LABEL io.k8s.display-name="sample-component-golang"
LABEL version="1.0.0"
LABEL release="1"
LABEL vendor="Red Hat, Inc."
LABEL distribution-scope="public"
LABEL url="https://github.com/konflux-ci/sample-component-golang"
LABEL maintainer="Konflux CI"
LABEL com.redhat.component="sample-component-golang"

CMD ["/sample-component-golang"]
