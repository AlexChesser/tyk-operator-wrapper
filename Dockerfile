FROM golang:1.17.13 as builder
## NOTE NOTE NOTE:
##    at the moment the TYK operator's release branch does not have
##    the ability to output snapshots when the main tyk operator DOES
##    offer the snapshot functionality, the "compile the operator" step
##    will no longer be necessary and can be replaced with
##
WORKDIR /build
RUN git clone --depth 1 https://github.com/TykTechnologies/tyk-operator.git .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o manager main.go

FROM alpine/k8s:1.23.16

WORKDIR /workspace
## TODO: when tyk operator includes snapshot capability by default, 
##       replace the line 2 below with the line below
#COPY --from=tykio/tyk-operator /manager ./tyk-operator
COPY --from=builder ./build/manager ./tyk-operator

# Create startup script to connect to the correct EKS instance
RUN echo "aws eks update-kubeconfig --region us-east-1 --name \${K8S_CLUSTER_NAME}" > configure-k8s.sh \
    && chmod +x configure-k8s.sh

# Add a one-line command script for outputting API and POLICY defs
RUN echo "./tyk-operator --separate --category \${API_EXPORT_CATEGORY} --policy /output/policy.yaml --apidef /output/apidef.yaml" > export-defs.sh \
    && chmod +x export-defs.sh

RUN echo "#!/bin/bash" > connect-and-export.sh \
    && echo "/workspace/configure-k8s.sh && /workspace/export-defs.sh" >> connect-and-export.sh \
    && chmod +x connect-and-export.sh

CMD  "./configure-k8s.sh" && /bin/bash
