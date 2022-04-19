#!/bin/bash
exit $(curl -s https://api.github.com/repos/coolsnowwolf/lede/commits\?per_page\=1 | jq -r "((now - (.[].commit.author.date | fromdateiso8601) )  / (60*60*24)  | trunc)")
