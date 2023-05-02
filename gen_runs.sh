#!/bin/bash

BASE_DIR=$(dirname "$0")

for features in wav2vec2_audeering_ft_c_mean wav2vec_c_mean; do
    for conffile in "$BASE_DIR/configs/logo"/*.yaml; do
        name=$(basename -s.yaml "$conffile")
        echo ertk-cli exp2 "$conffile" data.features=$features model.type=sk/lr model.config="\\\${cwdpath:conf/clf/sk/lr/default.yaml}" results="$BASE_DIR/results/logo/$features/$name.csv"
    done
done

for features in wav2vec2_audeering_ft_c_mean wav2vec_c_mean; do
    for exp in "$BASE_DIR/configs/within"/*; do
        for conffile in "$exp"/*.yaml; do
            name=$(basename -s.yaml "$conffile")
            name=$(basename "$exp")/"$name"
            echo ertk-cli exp2 "$conffile" data.features=$features model.type=sk/lr model.config="\\\${cwdpath:conf/clf/sk/lr/default.yaml}" results="$BASE_DIR/results/within/$features/$name.csv"
        done
    done
done

for features in wav2vec2_audeering_ft_c_mean wav2vec_c_mean; do
    for exp in "$BASE_DIR/configs/pairwise"/*; do
        for conffile in "$exp"/*.yaml; do
            name=$(basename -s.yaml "$conffile")
            name=$(basename "$exp")/"$name"
            echo ertk-cli exp2 "$conffile" data.features=$features model.type=sk/lr model.config="\\\${cwdpath:conf/clf/sk/lr/default.yaml}" results="$BASE_DIR/results/pairwise/$features/$name.csv"
        done
    done
done
