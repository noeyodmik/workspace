import json, io, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

with open(r'C:\Users\sapin\.gemini\antigravity\brain\74680e52-3081-46ff-b0a6-44b260d1c1bd\.system_generated\logs\transcript.jsonl', 'r', encoding='utf-8') as f:
    for line in f:
        data = json.loads(line)
        idx = data.get('step_index')
        if idx and 2540 <= idx <= 2590:
            if data.get('source') in ['USER_EXPLICIT', 'MODEL'] and data.get('type') in ['USER_INPUT', 'PLANNER_RESPONSE']:
                print(f"=== STEP {idx} [{data.get('source')}] ===")
                print(data.get('content') or '')
