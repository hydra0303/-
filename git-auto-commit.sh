#!/bin/bash
cd ~/.todo
git add todo.txt
git commit -m "업데이트: $(date +'%Y-%m-%d %H:%M:%S')" >/dev/null 2>&1
