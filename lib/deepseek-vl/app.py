import sys
import logging
import traceback
from flask import Flask, request, jsonify
from transformer.model import TransformerModel

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

model = None
try:
    # Initialize model from HuggingFace
    logger.info("Initializing transformer model...")
    model = TransformerModel("deepseek-ai/deepseek-vl-1.3b-base")
    logger.info("Model initialized successfully")
except Exception as e:
    logger.error(f"Error loading model: {str(e)}")
    logger.error(traceback.format_exc())
    raise

@app.route('/generate', methods=['POST'])
def generate():
    global model

    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400

    # Parse JSON from request
    try:
        data = request.get_json()
        prompt = data.get('prompt')
        images = data.get('images')

        if not prompt:
            return jsonify({"error": "Missing 'prompt' field in request"}), 400

        result = model.generate(prompt, images)
        return jsonify({"response": result})

    except Exception as e:
        error_message = f"Error during prediction: {str(e)}"
        logger.error(error_message, exc_info=True)
        return jsonify({"error": error_message}), 500