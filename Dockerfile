FROM alpine/k8s:1.23.16

WORKDIR /workspace
COPY --from=tykio/tyk-operator:v0.13.0 /manager ./tyk-operator

# Create startup script to connect to the correct EKS instance
RUN echo "aws eks update-kubeconfig --region us-east-1 --name \${K8S_CLUSTER_NAME}" > configure-k8s.sh \
    && chmod +x configure-k8s.sh

# Add a one-line command script for outputting API and POLICY defs
RUN echo "echo exporting apis and policies for category \${API_EXPORT_CATEGORY}" > export-defs.sh \
    && echo "cd /output" >> export-defs.sh \
    && echo "echo RUNNING COMMAND: /workspace/tyk-operator -separate -category \${API_EXPORT_CATEGORY}" >> export-defs.sh \
    && echo "/workspace/tyk-operator -separate -category \${API_EXPORT_CATEGORY}" >> export-defs.sh \
    && chmod +x export-defs.sh

RUN echo "#!/bin/bash" > connect-and-export.sh \
    && echo "/workspace/configure-k8s.sh && /workspace/export-defs.sh" >> connect-and-export.sh \
    && chmod +x connect-and-export.sh

CMD  "./configure-k8s.sh" && /bin/bash
