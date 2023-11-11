import pexpect
import time

class BtHandler:
    def __init__(self, mac: str):
        self.mac: str = mac
        self.proc: None | pexpect.pty_spawn.spawn = None

    def start_hb_mon(self):
        CMD = f"gatttool -b {self.mac} -I -t random"
        gt = pexpect.spawn(CMD)
        self.proc = gt

        attempt = 0
        while (1):
            gt.expect(r"\[LE]\>")
            gt.sendline("connect")
            try:
                i = gt.expect(["Connection successful.", r"\[CON\]"], timeout=30)
                print(f"Connection successful to {self.mac}")
                if i == 0:
                    gt.expect(r"\[LE\]>", timeout=30)
                break
            except pexpect.TIMEOUT:
                attempt += 1
                print(f"retry attempt {attempt}")
                continue

        time.sleep(2)
        gt.sendline("char-write-req 0x001d 0100")
        time.sleep(2)
        while 1:
            try:
                gt.expect("Notification handle = 0x001c value: ([0-9a-f ]+)", timeout=10)
            except pexpect.TIMEOUT:
                print("timeout")
                break
            except KeyboardInterrupt:
                break
        
            data = gt.match.group(1).strip().decode().split()[-1]
            print(int(data, 16))
