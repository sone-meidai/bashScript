#!/bin/bash

# Tìm tất cả các tiến trình autossh đang chạy
PIDS=$(pgrep -af autossh)

# Nếu có tiến trình autossh đang chạy
if [ -n "$PIDS" ]; then
  echo "Đang đóng tất cả các tunnel..."
  # Dùng xargs để gửi tín hiệu TERM cho từng tiến trình
  echo "$PIDS" | xargs kill
else
  echo "Không tìm thấy tiến trình autossh nào đang chạy."
fi
