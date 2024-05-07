# Huggingface's text-embedding-inference app

Deploy HuggingFace's 🤗 [text-embedding-inference](https://github.com/huggingface/text-embeddings-inference) Apolo app.


Important configurations (helm values):
```yaml
model: # Defines which model to serve
  modelHFName: ""
  modelRevision:

resources: # Specify resource constraints
  requests:
    cpu: 1
    memory: 4Gi
    nvidia.com/gpu: 1
  limits:
    nvidia.com/gpu: 1

nodeSelector:
  platform.neuromation.io/nodepool: gpu-2x-2080ti-2xnvidia-geforce-rtx-2080ti   # Specify which nodepool to use


env:
    HUGGING_FACE_HUB_TOKEN=<token> # HuggingFace token to use while downloading the model
```