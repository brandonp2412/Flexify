import json
import copy

with open('drift_schemas/db/drift_schema_v55.json', 'r') as f:
    v55 = json.load(f)

v56 = copy.deepcopy(v55)
for entity in v56['entities']:
    if entity['type'] == 'table' and entity['data']['name'] == 'gym_sets':
        entity['data']['columns'].append({
            "name": "rep_duration",
            "getter_name": "repDuration",
            "moor_type": "real",
            "nullable": False,
            "customConstraints": None,
            "default_dart": "const CustomExpression('0.0')",
            "default_client_dart": None,
            "dsl_features": []
        })
        break

for sql in v56.get('fixed_sql', []):
    if sql['name'] == 'gym_sets':
        sql['sql'][0]['sql'] = sql['sql'][0]['sql'].replace(')', ', "rep_duration" REAL NOT NULL DEFAULT 0.0)')
        break

with open('drift_schemas/db/drift_schema_v56.json', 'w') as f:
    json.dump(v56, f, indent=2)

v57 = copy.deepcopy(v56)
for entity in v57['entities']:
    if entity['type'] == 'table' and entity['data']['name'] == 'plan_exercises':
        entity['data']['columns'].extend([
            {
                "name": "increment_weight",
                "getter_name": "incrementWeight",
                "moor_type": "real",
                "nullable": True,
                "customConstraints": None,
                "default_dart": None,
                "default_client_dart": None,
                "dsl_features": []
            },
            {
                "name": "increment_reps",
                "getter_name": "incrementReps",
                "moor_type": "real",
                "nullable": True,
                "customConstraints": None,
                "default_dart": None,
                "default_client_dart": None,
                "dsl_features": []
            },
            {
                "name": "increment_duration",
                "getter_name": "incrementDuration",
                "moor_type": "real",
                "nullable": True,
                "customConstraints": None,
                "default_dart": None,
                "default_client_dart": None,
                "dsl_features": []
            }
        ])
        break

for sql in v57.get('fixed_sql', []):
    if sql['name'] == 'plan_exercises':
        sql['sql'][0]['sql'] = sql['sql'][0]['sql'].replace(')', ', "increment_weight" REAL NULL, "increment_reps" REAL NULL, "increment_duration" REAL NULL)')
        break

with open('drift_schemas/db/drift_schema_v57.json', 'w') as f:
    json.dump(v57, f, indent=2)
