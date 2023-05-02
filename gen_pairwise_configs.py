from itertools import permutations
from pathlib import Path
from typing import Tuple
import copy

import click

from ertk.dataset import DataSelector
from ertk.dataset.dataset import _RemoveGroups
from ertk.train import ExperimentConfig, EvalConfig


@click.command()
@click.argument("config_file", type=Path)
@click.argument("part")
@click.argument("groups", nargs=-1)
@click.option("--output", type=Path)
def main(config_file: Path, part: str, groups: Tuple[str], output: Path):
    exp_config = ExperimentConfig.from_file(config_file)
    output.mkdir(parents=True, exist_ok=True)

    for g1, g2 in permutations(groups, 2):
        eval_config = EvalConfig(
            train=DataSelector(groups={part: _RemoveGroups(keep=[g1])}),
            valid=DataSelector(groups={part: _RemoveGroups(keep=[g1])}),
            test=DataSelector(groups={part: _RemoveGroups(keep=[g2])}),
            inner_kfold=2,
        )
        data_config = copy.deepcopy(exp_config.data)
        if part == "corpus":
            for d in list(data_config.datasets):
                if d not in [g1, g2]:
                    data_config.datasets.pop(d)
        config = ExperimentConfig(
            name=exp_config.name,
            model=exp_config.model,
            data=data_config,
            eval=eval_config,
        )
        ExperimentConfig.to_file(config, output / f"{g1}__{g2}.yaml")


if __name__ == "__main__":
    main()
