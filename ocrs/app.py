#!/usr/bin/env python3

import base64
from logging.config import dictConfig
import re

import ddddocr
from flask import Flask, request


dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'stream': 'ext://flask.logging.wsgi_errors_stream',
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})


app = Flask(__name__)

ocr_engine = ddddocr.DdddOcr()

@app.route("/ocr", methods=["POST"])
def ocr():
    app.logger.info("ocr request received, image size: %d", len(request.json["image_base64"]))
    image_base64 = request.json["image_base64"]
    image_base64 = re.sub("data:image/\\w+;base64,", "", image_base64)
    image_bytes = base64.b64decode(image_base64.encode("utf-8"))
    text = ocr_engine.classification(image_bytes)
    app.logger.info("ocr result: %s", text)
    return {"text": f"{text}"}
