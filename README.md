# procon-tool

A tool for programming contest.


## Disclaimer

- This repo is only for me.
- There's no warranty for backword compatibility, etc.


## Requirements

- Bash
- Python 3
- `pcregrep`
- [Competitive Companion](https://github.com/jmerle/competitive-companion)


## Installation

Download this repo.

```
$ cd /path/to/this/repo
$ pip install -r requimements.txt
```


## Currently Supported things

### Site of programming contest

- AtCoder

(You can easily support other sites if [Competitive Companion](https://github.com/jmerle/competitive-companion) support it.)

### Language

- Rust
- Python


## How to use

You need to set enviroment variable `PROCON_TOOL_MASTER_DATA_DIRECTORY`.
This variable indicates where the test cases are downloaded.
To set enviroment variable, I recommend [direnv](https://github.com/direnv/direnv).

Example:

```
$ cd /path/to/your/procon/repo
$ mkdir master-data
$ # edit .envrc
$ cat .envrc
export PROCON_TOOL_MASTER_DATA_DIRECTORY=$PWD/master-data
$ direnv allow
```

### Download test cases

`procon-tool` provides a way to download test cases collaborating with [Competitive Companion](https://github.com/jmerle/competitive-companion).

```
$ cd /path/to/your/procon/repo
$ procon-tool test-download-cc
```

The above launch a local server that receive POST requests from Competitive Companion.
For example, if you visit https://atcoder.jp/contests/abc131/tasks/abc131_a and click Competitive Companion,
test cases will be downloaded under `PROCON_TOOL_MASTER_DATA_DIRECTORY` as the following.

```
$ procon-tool test-download-cc
 * Serving Flask app "main" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: on
 * Running on http://0.0.0.0:4244/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 204-367-024
  Generate tests for site = atcoder, contest = abc131, task = a
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/01/input.txt
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/01/output.txt
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/02/input.txt
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/02/output.txt
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/03/input.txt
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/03/output.txt
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/04/input.txt
    Generated: /Users/takeshi.okada/src/github.com/kenoss/contest-atcoder/new/master-data/atcoder/abc131/a/test-case/04/output.txt
127.0.0.1 - - [29/Jun/2019 19:28:27] "POST / HTTP/1.1" 200 -
```

### Test your program using test cases

```
$ cd /path/to/your/procon/repo/2019-06-22.atcoder.abc131/a
$ procon-tool test 1
----------------------------------------------------------------------------------------------------
    Finished debug [unoptimized + debuginfo] target(s) in 0.0 secs
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
OK: 01
----------------------------------------------------------------------------------------------------
got:
    Finished debug [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/procon`
Bad
----------------------------------------------------------------------------------------------------
expected:
Bad
----------------------------------------------------------------------------------------------------
$ procon-tool test
----------------------------------------------------------------------------------------------------
    Finished debug [unoptimized + debuginfo] target(s) in 0.0 secs
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
OK: 01
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
OK: 02
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
OK: 03
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
OK: 04
----------------------------------------------------------------------------------------------------

```
