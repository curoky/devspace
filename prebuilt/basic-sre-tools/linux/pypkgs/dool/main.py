#!/usr/bin/env python3
import re
import sys

from dool import __main__

if __name__ == "__main__":
    sys.argv[0] = re.sub(r"(-script\.pyw|\.exe)?$", "", sys.argv[0])
    sys.exit(__main__.__main())
