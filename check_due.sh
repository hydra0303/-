#!/bin/bash

TODO_FILE="$HOME/.todo/todo.txt"
CURRENT_TIME=$(date +%H:%M)

while IFS= read -r line; do
    if [[ "$line" =~ due:([0-9]{2}):([0-9]{2}) ]]; then
        DUE_HOUR="${BASH_REMATCH[1]}"
        DUE_MINUTE="${BASH_REMATCH[2]}"
        DUE_TIME="${DUE_HOUR}:${DUE_MINUTE}"

        NOW_SEC=$(date +%s)
        DUE_SEC=$(date -d "$DUE_TIME" +%s 2>/dev/null)
        if [[ -z "$DUE_SEC" ]]; then
            echo "⚠️ 시간 파싱 실패: $DUE_TIME"
            continue
        fi
        DIFF_SEC=$((DUE_SEC - NOW_SEC))

        if (( DIFF_SEC > 0 && DIFF_SEC < 3600 )); then
            echo "⏰ '$line' → $DUE_TIME 에 알림 예정 ($DIFF_SEC초 후)"
            ( sleep "$DIFF_SEC" && echo -e "\a✅ [알림] 할 일 시간입니다: $line" ) &
        fi
    fi
done < "$TODO_FILE"
