
Setup glcoud and access

Setup dataset and tables for statistics

```bash
chmod +x upsert-bq-table.sh
chmod +x upsert-bq-dataset.sh
./upsert-bq-dataset.sh
```

Add some test data

```bash
chmod +x insert-test-data.sh
./insert-test-data.sh
```

Setup data sync for statistics

```bash
chmod +x upsert-bq-scheduled-queries.sh
./upsert-bq-scheduled-queries.sh
```

Update schema or scheduled query
