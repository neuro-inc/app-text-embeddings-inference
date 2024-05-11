# Huggingface's text-embedding-inference app

Deploy HuggingFace's 🤗 [text-embedding-inference](https://github.com/huggingface/text-embeddings-inference) Apolo app.

## Platform deploymet example:
This example deploys `nomic-ai/nomic-embed-text-v1` embeddings model.

```yaml
neuro run --pass-config image:app-deployment -- install https://github.com/neuro-inc/app-text-embeddings-inference \
  embeddings tei charts/app-text-embedding-inference \
  --set "model.modelHFName=nomic-ai/nomic-embed-text-v1" \
  --set "resources.requests.cpu=1" \
  --set "resources.requests.memory=4Gi" \
  --set "resources.requests.nvidia\.com/gpu=1" \
  --set "resources.limits.nvidia\.com/gpu=1" \
  --set "nodeSelector.platform\.neuromation\.io/nodepool=gpu-2x-3090-2xnvidia-geforce-rtx-3090" \
  --set 'serverExtraArgs[0]=--max-client-batch-size=100'
```


# Important configs (helm values):
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
