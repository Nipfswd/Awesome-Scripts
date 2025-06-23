# Local File Search Engine with Fuzzy Matching

A simple Python tool to index files in a directory and perform fuzzy filename searches using [RapidFuzz](https://github.com/maxbachmann/rapidfuzz).

---

## Features

- Recursively index all files under a specified directory  
- Save the file index as a JSON file (`file_index.json`)  
- Fuzzy search filenames using RapidFuzz’s `WRatio` scorer  
- Return best matches with relevance scores  
- Command-line interface with indexing and searching modes  

---

## Requirements

- Python 3.6+  
- [rapidfuzz](https://pypi.org/project/rapidfuzz/) library  
  Install via pip:
```bash
pip install rapidfuzz
```

## Usage

- Index files
- Index all files under a directory and save the index:
```bash
python file_search.py --index /path/to/directory
```
- This will create/update file_index.json with all files indexed.

## Search files

- Search indexed files by filename with fuzzy matching:
```bash
python file_search.py --search "filename query" [--limit N]
```
- ```bash--search``` or ```-s```: Query string to search for

- ```bash--limit``` or ```bash-l```: (Optional) Max number of results to return (default: 10)
