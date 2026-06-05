.PHONY: check reports smoke verify clean-generated

check:
	python3 scripts/check_all.py

reports:
	python3 scripts/refresh_reports.py

smoke:
	rm -rf tmp/splits/smoke
	python3 scripts/export_train_eval_split.py --output-dir tmp/splits/smoke --exclude-generated-expansion --include-contrastive-heldout
	python3 scripts/export_training_corpus.py --output tmp/smoke-corpus.jsonl --include-docs --exclude-generated-expansion
	test -s tmp/splits/smoke/train.jsonl
	test -s tmp/splits/smoke/heldout.jsonl
	test -s tmp/smoke-corpus.jsonl

verify: check reports smoke

clean-generated:
	rm -rf tmp datasets/splits
