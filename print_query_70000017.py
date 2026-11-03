with open(r'C:\Users\sapin\.gemini\antigravity\brain\74680e52-3081-46ff-b0a6-44b260d1c1bd\.system_generated\steps\2034\output.txt', 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

for i in range(40, 100):
    if i < len(lines):
        print(f"{i}: {lines[i].strip()}")

