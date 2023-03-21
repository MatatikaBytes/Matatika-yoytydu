#!/bin/bash

# Exit on error
set -e

# Meltano setup
meltano install extractor "$EXTRACTOR"
meltano install loader "$LOADER"
meltano install transform dbt-"$EXTRACTOR"
meltano install transformer dbt

# Run the elt, and dbt commands and tests
meltano elt "$EXTRACTOR" "$LOADER" --transform=skip
meltano invoke dbt deps
meltano invoke dbt snapshot --select github_dim_repositories_snapshot
meltano invoke dbt run -m tap_github