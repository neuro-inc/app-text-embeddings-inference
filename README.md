# Huggingface's text-embedding-inference app

Deploy HuggingFace's 🤗 [text-embedding-inference](https://github.com/huggingface/text-embeddings-inference) Apolo app.

## Platform deploymet example:
This example deploys `nomic-ai/nomic-embed-text-v1` embeddings model.

```yaml
apolo run --pass-config ghcr.io/neuro-inc/app-deployment -- install https://github.com/neuro-inc/app-text-embeddings-inference \
  text-embeddings-inference tei charts/app-text-embedding-inference \
  --set timeout=600 \
  --set "model.modelHFName=nomic-ai/nomic-embed-text-v1" \
  --set 'serverExtraArgs[0]=--max-client-batch-size=100' \
  --set "image.tag=hopper-1.2.3" \ # optional
  --set "preset_name=H100x1" \  # set needed preset
  --set "ingress.enabled=True" \ # optional
  --set "ingress.clusterName=scottdc" # optional
```
