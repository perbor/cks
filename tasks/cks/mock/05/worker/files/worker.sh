#!/bin/bash
echo " *** worker pc mock-5  "

# artifacts for tasks 1 and 2 (falco / sysdig logs)
mkdir -p /var/work/tests/artifacts/1/ /var/work/tests/artifacts/2/
chown -R ubuntu:ubuntu /var/work/tests/artifacts/1/ /var/work/tests/artifacts/2/
