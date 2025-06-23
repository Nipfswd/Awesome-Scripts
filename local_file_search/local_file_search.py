import os
import json
import argparse
from pathlib import Path
from rapidfuzz import fuzz, process

INDEX_FILE = "file_index.json"

def index_files(root_dir):
    files = []
    root = Path(root_dir)
    for filepath in root.rglob("*"):
        if filepath.is_file():
            files.append(str(filepath.resolve()))
    print(f"Indexed {len(files)} files from {root_dir}")
    return files

def save_index(files, index_path=INDEX_FILE):
    with open(index_path, "w", encoding="utf-8") as f:
        json.dump(files, f, indent=2)

def load_index(index_path=INDEX_FILE):
    if not os.path.exists(index_path):
        print("No index found. Please run indexing first.")
        return []
    with open(index_path, "r", encoding="utf-8") as f:
        return json.load(f)

def search_files(files, query, limit=10):
    # We'll use rapidfuzz process.extract to get best matches by filename only
    filenames = [os.path.basename(f) for f in files]
    results = process.extract(query, filenames, scorer=fuzz.WRatio, limit=limit)
    # results is list of tuples (filename, score, index)
    # Return matching full paths with scores
    return [(files[idx], score) for _, score, idx in results]

def main():
    parser = argparse.ArgumentParser(description="Local File Search Engine with Fuzzy Matching")
    parser.add_argument("--index", "-i", metavar="DIR", help="Index files under this directory")
    parser.add_argument("--search", "-s", metavar="QUERY", help="Search files by name")
    parser.add_argument("--limit", "-l", type=int, default=10, help="Max search results")
    args = parser.parse_args()

    if args.index:
        files = index_files(args.index)
        save_index(files)
    elif args.search:
        files = load_index()
        if not files:
            return
        results = search_files(files, args.search, args.limit)
        print(f"Top {len(results)} results for '{args.search}':\n")
        for path, score in results:
            print(f"[{score:3}] {path}")
    else:
        print("Use --index DIR to index files or --search QUERY to search.")

if __name__ == "__main__":
    main()
