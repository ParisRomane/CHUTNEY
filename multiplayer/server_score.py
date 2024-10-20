import json
import socket
import os
import signal
import sys
from typing import Literal, TypeAlias, TypedDict
from types import FrameType

FILENAME = 'scores.json'
HOST = 'localhost'
PORT = 12345

class OkResponse(TypedDict):
    status: Literal["success"]
    score: dict[str, int]

class ErrorResponse(TypedDict):
    status: Literal["failure"]
    message: str

Response: TypeAlias = OkResponse | ErrorResponse

def load_scores() -> dict[str, int]:
    if os.path.exists(FILENAME):
        with open(FILENAME, 'r') as f:
            return json.load(f)
    else:
        return {}

def save_scores(scores: dict[str, int]) -> None:
    with open(FILENAME, 'w') as f:
        json.dump(scores, f)

def handle_exit(signum: int, frame: FrameType | None):
    print("Saving and exiting...")
    save_scores(scores)
    sys.exit(0)

signal.signal(signal.SIGINT, handle_exit)
signal.signal(signal.SIGTERM, handle_exit)

# Charger les scores depuis le fichier
scores = load_scores()

# Ouvrir un socket
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()

    print(f"Server running {HOST}:{PORT}")

    while True:
        conn, addr = s.accept()
        with conn:
            print(f"{addr} connected")
            data = conn.recv(1024)
            if not data:
                continue

            try:
                request = json.loads(data.decode('utf-8'))
                action = request.get('action')
                response: Response

                if action == 'get_score':
                    response = {
                        "status": "success",
                        "score": scores
                    }
                elif action == 'put_score':
                    name = request.get('name')
                    score = request.get('score')
                    if name and isinstance(score, int):
                        scores[name] = score
                        response = {
                            "status": "success",
                            "score": scores
                        }
                    else:
                        response = {
                            "status": "failure",
                            "message": "Invalid 'name' or 'score'"
                        }
                else:
                    response = {
                        "status": "failure",
                        "message": "Unknown action"
                    }

            except json.JSONDecodeError:
                response = {
                    "status": "failure",
                    "message": "Invalid JSON format"
                }

            conn.sendall(json.dumps(response).encode('utf-8'))

