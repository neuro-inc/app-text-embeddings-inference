import typing as t

from apolo_app_types import HuggingFaceModel
from apolo_app_types.clients.kube import get_service_host_port
from apolo_app_types.outputs.common import INSTANCE_LABEL
from apolo_app_types.outputs.utils.ingress import get_ingress_host_port
from apolo_app_types.protocols.common.openai_compat import OpenAICompatEmbeddingsAPI
from apolo_apps_text_embeddings_inference.types import TextEmbeddingsInferenceAppOutputs
from apolo_app_types.outputs.base import BaseAppOutputsProcessor



async def get_tei_outputs(
    helm_values: dict[str, t.Any],
    app_instance_id: str,
) -> TextEmbeddingsInferenceAppOutputs:
    labels = {
        "application": "text-embeddings-inference",
        INSTANCE_LABEL: app_instance_id,
    }
    internal_host, internal_port = await get_service_host_port(match_labels=labels)
    internal_api = None
    model_prop = helm_values.get("model")
    if model_prop:
        hf_model = HuggingFaceModel(model_hf_name=model_prop.get("modelHFName"))
    else:
        hf_model = None
    if internal_host:
        internal_api = OpenAICompatEmbeddingsAPI(
            host=internal_host,
            port=int(internal_port),
            protocol="http",
            hf_model=hf_model,
        )

    host_port = await get_ingress_host_port(match_labels=labels)
    external_api = None
    if host_port:
        host, port = host_port
        external_api = OpenAICompatEmbeddingsAPI(
            host=host, port=int(port), protocol="https", hf_model=hf_model
        )
    return TextEmbeddingsInferenceAppOutputs(
        internal_api=internal_api,
        external_api=external_api,
    )

class TextEmbeddingsOutputProcessor(BaseAppOutputsProcessor[TextEmbeddingsInferenceAppOutputs]):
    async def _generate_outputs(
        self,
        helm_values: dict[str, t.Any],
        app_instance_id: str,
    ) -> TextEmbeddingsInferenceAppOutputs:
        return await get_tei_outputs(helm_values, app_instance_id)

