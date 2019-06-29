'''
ONELINE_HELP: Generate test cases collaborating with with the browser extension "Competitive Companion".
'''


import argparse
import flask
import os
import pathlib
import re
from distutils.util import strtobool

app = flask.Flask(__name__)


PORT = 4244


###
### Arguments
###

def parse_args():
    parser = argparse.ArgumentParser(description='Generate test cases collaborating with with the browser extension "Competitive Companion".')

    parser.add_argument('--use-master-data', type=strtobool, default=True)

    return parser.parse_args()


###
### Saver
###

class SaverBase:
    def generate_tests(self, site, contest, task, tests):
        print(f"  Generate tests for site = {site.IDENTIFIER}, contest = {contest}, task = {task}")

        for (i, test) in enumerate(tests):
            self._generate_test(site, contest, task, i+1, test)

    def _generate_test(self, site, contest, task, i, test):
        raise NotImplementedError()


class SaverMasterData(SaverBase):
    '''
    Save test files under the directory for master data.

    The environment variable `PROCON_TOOL_MASTER_DATA_DIRECTORY` must be set.

    Example:
        PROCON_TOOL_MASTER_DATA_DIRECTORY:
            /path/to/master-data
        generates test files like:
            /path/to/master-data/atcoder/abc000/a/test-case/01/input.txt
    '''

    def _generate_test(self, site, contest, task, i, test):
        p_ = os.environ.get('PROCON_TOOL_MASTER_DATA_DIRECTORY')

        if p_ is None:
            raise Exception('environment variable `PROCON_TOOL_MASTER_DATA_DIRECTORY` not set.')

        p = pathlib.Path(p_).resolve()

        if not p.is_dir():
            raise Exception(f"directory does not exists: {p}")

        i_ = '{:0>2}'.format(i)
        d = p / site.IDENTIFIER / contest / task / 'test-case' / i_
        d.mkdir(parents=True, exist_ok=True)

        for key in ['input', 'output']:
            p = d / f"{key}.txt"
            with open(p, mode='w') as f:
                f.write(test[key])
            print(f"    Generated: {p}")


class SaverContest(SaverBase):
    '''
    Save test files under current directory.  Current directory corresponds to contest.

    Example:
        current directory:
            /path/to/2000-01-01.atcoder.abc000
        generates test files like:
            /path/to/2000-01-01.atcoder.abc000/a/procon-tool/test-case/01/input.txt
    '''

    def _generate_test(self, site, contest, task, i, test):
        p = pathlib.Path().resolve() / task

        if not p.is_dir():
            raise Exception(f"directory does not exists: {p}")

        i_ = '{:0>2}'.format(i)
        d = p / 'procon-tool/test-case' / i_
        d.mkdir(parents=True, exist_ok=True)

        for key in ['input', 'output']:
            p = d / f"{key}.txt"
            with open(p, mode='w') as f:
                f.write(test[key])
            print(f"    Generated: {p}")


###
### SiteHandler
###

class HandlerBase:
    def __init__(self, helper):
        self._helper = helper


class HandlerAtCoder(HandlerBase):
    IDENTIFIER = 'atcoder'
    URL_MATCHER = re.compile(r'^https://atcoder.jp/')

    def handle(self, j):
        contest = re.compile(r'/contests/([^/]+)').search(j['url']).group(1)
        task = re.compile(r'/tasks/[^/]+_(.)').search(j['url']).group(1)

        self._helper.generate_tests(self, contest, task, j['tests'])


SITES = [
    HandlerAtCoder,
]


###
### Main
###


SAVER = None


def handle(j):
    url = j['url']

    for site_klass in SITES:
        if site_klass.URL_MATCHER.match(url):
            site_klass(SAVER).handle(j)
            return

    raise Exception('Unknown site')


@app.route('/', methods=['POST'])
def root():
    j = flask.request.json
    url = j['url']

    handle(j)
    return flask.jsonify(), 200


def debug():
    j = {
        'group': 'AtCoder Beginner Contest 131',
        'input': {'type': 'stdin'},
        'interactive': False,
        'languages': {
            'java': {
                'mainClass': 'Main',
                'taskClass': 'FMustBeRectangular'},
        },
        'memoryLimit': 1024,
        'name': 'F - Must Be Rectangular!',
        'output': {
            'type': 'stdout',
        },
        'testType': 'single',
        'tests': [
            {'input': '3\n1 1\n5 1\n5 5\n', 'output': '1\n'},
            {'input': '2\n10 10\n20 20\n', 'output': '0\n'},
            {'input': '9\n1 1\n2 1\n3 1\n4 1\n5 1\n1 2\n1 3\n1 4\n1 5\n', 'output': '16\n'},
        ],
        'timeLimit': 2000,
        'url': 'https://atcoder.jp/contests/abc131/tasks/abc131_f'
    }
    handle(j)


def main(args):
    global SAVER
    if args.use_master_data:
        SAVER = SaverMasterData()
    else:
        SAVER = SaverContest()

    app.debug = True
    app.run(host='0.0.0.0', port=PORT)
    # debug()


if __name__ == '__main__':
    args = parse_args()
    main(args)
