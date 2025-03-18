#!/bin/bash

ghdl -a --std=08 --workdir=lib -P=lib -frelaxed crystal.vhd
ghdl -a --std=08 --workdir=lib -P=lib -frelaxed segment7.vhd
ghdl -a --std=08 --workdir=lib -P=lib -frelaxed test_segment7.vhd

ghdl -e --std=08 --workdir=lib -P=lib -frelaxed test_segment7
ghdl -r --std=08 --workdir=lib -P=lib -frelaxed test_segment7 --vcd=test_segment7.vcd --stop-time=5000ns
