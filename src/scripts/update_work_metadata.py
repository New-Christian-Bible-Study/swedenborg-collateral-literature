import json
import logging
from pathlib import Path
from datetime import datetime
from typing import Dict, Any, Optional

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def work_metadata(work_id: str, update: Dict[str, Any] = None) -> Optional[Dict[str, Any]]:
    """Get or update work metadata."""
    try:
        file = Path(__file__).parent.parent.parent / 'data' / 'works.json'
        if not file.exists():
            return None

        with open(file, 'r', encoding='utf-8') as f:
            data = json.load(f)
            work = next((w for w in data if w.get('id') == work_id), None)
            
            if work and update:
                work.update(update)
                work['last_updated'] = datetime.now().isoformat()
                with open(file, 'w', encoding='utf-8') as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)
            return work
    except Exception as e:
        logging.error(f"Error: {e}")
        return None

if __name__ == "__main__":
    work_id = "example_work_id"
    if work_metadata(work_id):
        if work_metadata(work_id, {"title": "Updated Title", "description": "Updated description"}):
            logging.info("Updated successfully")
    else:
        logging.error(f"Work {work_id} not found") 