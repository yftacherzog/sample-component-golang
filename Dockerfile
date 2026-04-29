# Builder: Project Hummingbird / Red Hat Hardened Images (Go toolchain + shell/dnf)
FROM registry.access.redhat.com/hi/go@sha256:c4ffa96a970476d7e800500b72de36e818e1d95467d87c9ede8d604a0291d09a AS builder

WORKDIR /workspace

COPY --chmod=644 go.mod go.mod
COPY --chmod=644 go.sum go.sum
COPY --chmod=644 main.go main.go

RUN go mod download

RUN CGO_ENABLED=0 go build -o /opt/app-root/sample-component-golang main.go

# Runtime: minimal glibc base for static/dynamic binaries (distroless — no package manager)
FROM registry.access.redhat.com/hi/core-runtime@sha256:db98edef85606d87365343b32e2a86bba0572be49ed26e6488897b491dcef28d

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
