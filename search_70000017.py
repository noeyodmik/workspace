import re

with open(r'C:\Users\sapin\.gemini\antigravity\brain\74680e52-3081-46ff-b0a6-44b260d1c1bd\.system_generated\steps\2034\output.txt', 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")
for i, line in enumerate(lines):
    if '70000017' in line or '10:18:' in line:
        # print context around this line
        start = max(0, i - 15)
        end = min(len(lines), i + 10)
        print(f"--- MATCH AT LINE {i} ---")
        for j in range(start, end):
            print(f"{j}: {lines[j].strip()}")
        break

