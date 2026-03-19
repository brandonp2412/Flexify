dart run build_runner build -d
dart run drift_dev make-migrations
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/