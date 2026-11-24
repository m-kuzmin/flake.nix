#!/usr/bin/env python3

"""
Checks the inputs used to build this system and reports if any are outdated.

On startup, reads the system manifest and requirements files and prints the summary of how old each input is.

If the input is outdated (set by the requirements file), it will indicate it in the output.

Exit codes:
- 0: No errors and the inputs are not outdated
- 100: At least one input is outdated
- **Other exit codes are also possible**
"""


import json
from datetime import datetime, date, UTC


MANIFEST = "/etc/system-flake/version.json"
REQUIRE = "/etc/system-flake/requirements.json"



def main():
    needs_update = False

    with open(MANIFEST, encoding='utf-8') as manifest:
        inputs = json.load(manifest)

    with open(REQUIRE, encoding='utf-8') as manifest:
        require = json.load(manifest)

    with open("/etc/hostname", encoding='utf-8') as hostname:
        print(f'Inputs of {hostname.readline()}')

    max_input_name_len = max([len(k) for k in inputs.keys()])

    for name, metadata in inputs.items():
        ts = datetime.fromtimestamp(int(metadata['lastModified']), UTC)
        ymd = ts.strftime('%b %d, %Y')
        # Multiply by -1 so that future dates are automatically shown as -N days ago.
        # This has an UNINTENDED consequence of allowing negative requirements file dates to be compared correctly. (don't rely on that!)
        ago = -1 * (ts - datetime.now(UTC)).days

        padded_name = name + (' ' * (max_input_name_len - len(name)))

        warn_days = require.get(name, {'days': None}).get('days', None)
        if warn_days != None and ago > warn_days:
            needs_update = True
            print(f'\x1b[31m{padded_name} ⚠️ {ymd} ({ago}/{warn_days}d ago)\x1b[0m')
        else:
            print(f'{padded_name} 🗸  {ymd} ({ago}{f'/{warn_days}' if warn_days is not None else ''}d ago)')

    if needs_update:
        exit(100)


if __name__ == '__main__':
    main()
