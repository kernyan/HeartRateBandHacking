#! /usr/bin/env python3

import argparse

from ble_handler import BtHandler

IC4_HBM_MAC = "FE:3F:08:A0:0F:C7"

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--mac', '-m', type=str, default=IC4_HBM_MAC)
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_args()
    print(f"Connecting to {args.mac}")

    bt_handler = BtHandler(args.mac)
    bt_handler.start_hb_mon()
