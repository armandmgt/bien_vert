import torch
from transformers import AutoModelForCausalLM
import logging

from deepseek_vl.models import VLChatProcessor, MultiModalityCausalLM
from deepseek_vl.utils.io import load_pil_images

logger = logging.getLogger(__name__)


class TransformerModel:
    def __init__(self, model_name):
        self.vl_chat_processor: VLChatProcessor = VLChatProcessor.from_pretrained(model_name)
        self.tokenizer = self.vl_chat_processor.tokenizer

        self.vl_gpt: MultiModalityCausalLM = AutoModelForCausalLM.from_pretrained(model_name, trust_remote_code=True)
        self.vl_gpt = self.vl_gpt.to(torch.bfloat16).cpu().eval()

    def generate(self, prompt, images):
        conversation = [
            {
                "role": "User",
                "content": f"<image_placeholder>{prompt}.",
                "images": images
            },
            {
                "role": "Assistant",
                "content": ""
            }
        ]

        pil_images = load_pil_images(conversation)
        prepare_inputs = self.vl_chat_processor(
            conversations=conversation,
            images=pil_images,
            force_batchify=True
        ).to(self.vl_gpt.device)

        # run image encoder to get the image embeddings
        inputs_embeds = self.vl_gpt.prepare_inputs_embeds(**prepare_inputs)

        # run the model to get the response
        outputs = self.vl_gpt.language_model.generate(
            inputs_embeds=inputs_embeds,
            attention_mask=prepare_inputs.attention_mask,
            pad_token_id=self.tokenizer.eos_token_id,
            bos_token_id=self.tokenizer.bos_token_id,
            eos_token_id=self.tokenizer.eos_token_id,
            max_new_tokens=512,
            do_sample=False,
            use_cache=True
        )

        answer = self.tokenizer.decode(outputs[0].cpu().tolist(), skip_special_tokens=True)
        print(f"{prepare_inputs['sft_format'][0]}", answer)
