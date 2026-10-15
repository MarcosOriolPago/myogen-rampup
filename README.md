# Ramping up with myogen

A self-contained starting point for [myogen](https://github.com/ETHRoboticsClub/myogen): hand and wrist joint
angles in, forearm sEMG out. It simulates the glove motions of the NinaPro DB5 dataset and compares the simulated
EMG with the real EMG recorded during the same movements.

## Setup

Needs Linux or macOS, `git`, `curl`, `unzip` and Python >= 3.11.

```bash
./setup.sh               # clones myogen into ./myogen, makes .venv, pip install -e "myogen[examples,viewer]"
./download_ninapro.sh    # NinaPro DB5 subject 1 into data/ninapro_db5/s1 (~20 MB)
source .venv/bin/activate
jupyter notebook rampup.ipynb    # or open it in VS Code with the .venv kernel
```

- `PYTHON=python3.12 ./setup.sh` picks the interpreter. Running `setup.sh` again pulls the latest myogen.
- `./download_ninapro.sh 1 2 3` downloads several subjects; `./download_ninapro.sh all` downloads all ten (~200 MB).
- myogen is installed editable: changes under `myogen/src` apply on the next kernel restart.

## What is here

| | |
|---|---|
| `rampup.ipynb` | The walkthrough (about 4 minutes to run on 16 cores). |
| `ninapro.py` | Reads DB5 `.mat` files and converts the CyberGlove into model joint angles. `load_db5` is the loader for `mg.HandMotion.load`. |
| `setup.sh` | Clones and installs myogen. |
| `download_ninapro.sh` | Downloads NinaPro DB5. |
| `data/ninapro_db5/sN/` | The downloaded recordings: `SN_E1_A1.mat`, `SN_E2_A1.mat` and `SN_E3_A1.mat` are exercises 1-3. |
| `outputs/` | Recordings the notebook saves. |

## The notebook

1. **The data**: a DB5 recording's EMG, glove and movement labels.
2. **Glove to `HandMotion`**: `mg.HandMotion.load(path, load_db5)`. A loader returns the joint angles in the
   model's format.
3. **Simulator setup**: `Electrodes.myo()` (the DB5 armbands), `Subject`, `Simulator`.
4. **A simulation**: `sim.run(motion)` gives a `Recording` with the EMG, joint and muscle labels, and a quality
   check.
5. **A batch**: `sim.run([m1, m2, m3])` simulates in parallel processes, with one progress bar per motion.
6. **Real vs simulated EMG**: raw signals and 150 ms RMS envelopes, per channel and averaged; `mg.compare`
   statistics.
7. **Calibration**: `mg.calibrate` fits the device gain, noise and armband rotation to the real recording.
8. **Saving, loading and `mg.replay`**: the 3-D web viewer at http://localhost:8080. It runs until you interrupt
   the kernel.

The notebook simulates one minute of each recording. The full recordings are 10-20 minutes and take several
minutes each to simulate.

## Data

NinaPro DB5: 10 intact subjects with two Myo armbands (16 channels, 200 Hz) and a CyberGlove 2, doing 52
movements in 3 exercises. Source: https://ninapro.hevs.ch/instructions/DB5.html. If you use the data, cite:

> S. Pizzolato et al., "Comparison of six electromyography acquisition setups on hand movement classification
> tasks", PLoS ONE 12(10), 2017.
