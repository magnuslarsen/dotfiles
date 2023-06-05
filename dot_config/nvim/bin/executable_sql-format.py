#!/usr/bin/env python3
import sqlparse
import sys


def main():
    content = sys.stdin.read()
    print(sqlparse.format(
        content,
        keyword_case="upper",
        identifier_case="lower",
        reindent=True,
        reindent_aligned=False,
        output_format="sql",
        wrap_after=80,
        comma_first=False,
    ).strip())


if __name__ == "__main__":
    main()
