#!/usr/bin/env python3
import sys

import sqlfluff

# TODO: Python: capture whole string (with `"`, format it to use """?
#       That would also fix the one-line sql issue


def main():
    c = sys.stdin.read()
    print(
        sqlfluff.fix(c, dialect="postgres", config_path=".sqlfluff").strip()
    )


if __name__ == "__main__":
    main()
