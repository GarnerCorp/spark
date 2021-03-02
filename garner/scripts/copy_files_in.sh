#!/usr/bin/env bash
echo "Copying new distribution"
cp -r  ${0:a:h}/../../dist ${0:a:h}/../../garner
wait
echo "Copying in conf"
cp -r  ${0:a:h}/../conf ${0:a:h}/../../garner/dist