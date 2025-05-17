#!/bin/bash

TODO_FILE="$HOME/.todo/todo.txt"

while IFS= read -r line; do
    echo "읽은 라인: $line"
    if [[ "$line" =~ due:([0-9]{2}):([0-9]{2}) ]]; then
        DUE_HOUR="${BASH_REMATCH[1]}"
        DUE_MINUTE="${BASH_REMATCH[2]}"
        DUE_TIME="${DUE_HOUR}:${DUE_MINUTE}"

        # Powershell로 현재시간과 due시간 초단위 변환
        NOW_SEC=$(powershell.exe -Command "[int][double](New-TimeSpan -Start (Get-Date '00:00') -End (Get-Date (Get-Date -Format 'HH:mm'))).TotalSeconds")
        DUE_SEC=$(powershell.exe -Command "[int][double](New-TimeSpan -Start (Get-Date '00:00') -End (Get-Date '$DUE_TIME')).TotalSeconds")

        if [[ -z "$DUE_SEC" || -z "$NOW_SEC" ]]; then
            echo "⚠️ 시간 파싱 실패: $DUE_TIME"
            continue
        fi

        DIFF_SEC=$((DUE_SEC - NOW_SEC))
        echo "현재 시간(초): $NOW_SEC, 알림 시간(초): $DUE_SEC, 남은 시간: $DIFF_SEC초"

        if (( DIFF_SEC > 0 && DIFF_SEC < 3600 )); then
            echo "⏰ '$line' → $DUE_TIME 에 알림 예정 ($DIFF_SEC초 후)"
            # 알림 팝업 띄우기 (백그라운드 실행)
            ( sleep "$DIFF_SEC" && powershell.exe -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('할 일 시간입니다: $line')" ) &
        fi
    fi
done < "$TODO_FILE"



