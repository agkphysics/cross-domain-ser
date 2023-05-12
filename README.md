# Cross-domain SER experiments

This repository contains code to run cross-domain speech emotion
recognition (SER) experiments. The experiments are set as config files
using the [Emotion Recognition ToolKit
(ERTK)](https://github.com/Strong-AI-Lab/emotion).


## Setting up
In order to run the experiments, you must download and process the
datasets using ERTK. The easiest way to do this is clone the ERTK
repository and run the dataset processing scripts on each dataset once
you have downloaded it.

```
git clone https://github.com/Strong-AI-Lab/emotion.git
cd emotion
pip install -r requirements-dev.txt requirements.txt
pip install .
```
Then for each dataset:
```
cd datasets/CREMA-D
python process.py /path/to/CREMA-D
```
and so on. See the [ERTK
documentation](https://github.com/Strong-AI-Lab/emotion/blob/master/datasets/README.md)
for examples.


## Running experiments
Each experiment has a corresponding config file in the `configs/`
directory. The leave-one-domain-out (LODO) configs are manually created
and the pairwise configs can be generated using the
`gen_pairwise_configs.py` Python script:
```
python gen_pairwise_configs.py \
	configs/lodo/cross_lang_explicit_4class_2.yaml \
	language \
	am fr en de it es pt bn \
	--output configs/pairwise/cross_lang_explicit_4class_2/
```

The experiments are designed to be run from the root of the ERTK
repository. First you must generate the commands for experiments using
`gen_runs.sh`:
```
cd /.../emotion/
bash /path/to/gen_runs.sh > jobs.txt
```

You can then run multiple experiments in parallel:
```
ertk-util parallel_jobs \
	jobs.txt \
	--failed jobs.txt \
	--cpus $(nproc) > train.log
```

## Viewing results
The VENEC results can be created and viewed using the
`VENEC_results.ipynb` Jupyter notebook. The ESD and EmoFilm results can
be viewed similarly with their respective notebooks. The remaining
results can be viewed with the `main_results.ipynb` notebook.
