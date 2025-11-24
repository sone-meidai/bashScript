#!/bin/bash

TUNNEL=$1

# Nếu không truyền tham số, chạy tất cả các tunnel
if [ -z "$TUNNEL" ]; then
  echo "Không có tham số, sẽ chạy tất cả các tunnel."

  for TUNNEL_OPTION in "UK88" "XO88" "DA88" "ONE88" "LUCKY88" "THAI" "11BET" "TA88" "VODKA" "NET88" "CMS"; do
    case "$TUNNEL_OPTION" in
      UK88)
        DEST_IP="192.168.78.120"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel UK88..."
        CMD="autossh -M 20000 -f -L 9200:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.166.91.208 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      XO88)
        DEST_IP="192.168.76.196"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel XO88..."
        CMD="autossh -M 20001 -f -L 9201:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.162.73.251 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      DA88)
        DEST_IP="192.168.107.47"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel DA88..."
        CMD="autossh -M 20002 -f -L 9202:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.163.17.205 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      ONE88)
        DEST_IP="18.163.97.97"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel ONE88..."
        CMD="autossh -M 20003 -f -L 9203:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.166.108.212 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      LUCKY88)
        DEST_IP="192.168.20.166"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel LUCKY88..."
        CMD="autossh -M 20004 -f -L 9204:$DEST_IP:$DEST_PORT -p $SSH_PORT fe@18.163.160.30 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      THAI)
        DEST_IP="192.168.116.16"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel THAI..."
        CMD="autossh -M 20005 -f -L 9205:$DEST_IP:$DEST_PORT -p $SSH_PORT esms@43.198.213.72 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      11BET)
        DEST_IP="192.168.11.111"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel 11BET..."
        CMD="autossh -M 20006 -f -L 9206:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.163.171.126 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      TA88)
        DEST_IP="192.168.71.23"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel TA88..."
        CMD="autossh -M 20007 -f -L 9207:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.167.74.16 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      VODKA)
        DEST_IP="192.168.141.152"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel VODKA..."
        CMD="autossh -M 20008 -f -L 9208:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.163.19.62 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      NET88)
        DEST_IP="192.168.82.166"
        DEST_PORT="9200"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel NET88..."
        CMD="autossh -M 20009 -f -L 9209:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@16.163.60.169 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      CMS)
        DEST_IP="127.0.0.1"
        DEST_PORT="27017"
        SSH_PORT="22000"
        echo "Đang thiết lập tunnel CMS..."
        CMD="autossh -M 20010 -f -L 27018:$DEST_IP:$DEST_PORT -p $SSH_PORT daluzz@18.166.175.126 -i ~/.ssh/Daluzz9 -N"
        echo "Lệnh đang chạy: $CMD"
        $CMD
        ;;
      *)
        echo "Không hỗ trợ tunnel này: $TUNNEL_OPTION"
        ;;
    esac
  done

  exit 0
fi

# Nếu có tham số, xử lý theo tham số đã cho
case "$TUNNEL" in
  UK88)
    DEST_IP="192.168.78.120"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel UK88..."
    CMD="autossh -M 20000 -f -L 9200:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.166.91.208 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  XO88)
    DEST_IP="192.168.76.196"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel XO88..."
    CMD="autossh -M 20001 -f -L 9201:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.162.73.251 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  DA88)
    DEST_IP="192.168.107.47"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel DA88..."
    CMD="autossh -M 20002 -f -L 9202:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.163.17.205 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  ONE88)
    DEST_IP="18.163.97.97"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel ONE88..."
    CMD="autossh -M 20003 -f -L 9203:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.166.108.212 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  LUCKY88)
    DEST_IP="192.168.20.166"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel LUCKY88..."
    CMD="autossh -M 20004 -f -L 9204:$DEST_IP:$DEST_PORT -p $SSH_PORT fe@18.163.160.30 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  THAI)
    DEST_IP="192.168.116.16"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel THAI..."
    CMD="autossh -M 20005 -f -L 9205:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.167.170.199 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  11BET)
    DEST_IP="192.168.11.111"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel 11BET..."
    CMD="autossh -M 20006 -f -L 9206:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.163.171.126 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  TA88)
    DEST_IP="192.168.71.23"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel TA88..."
    CMD="autossh -M 20007 -f -L 9207:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@18.167.74.16 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  VODKA)
    DEST_IP="192.168.141.152"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel TA88..."
    CMD="autossh -M 20008 -f -L 9208:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@43.198.162.25 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  NET88)
    DEST_IP="192.168.82.166"
    DEST_PORT="9200"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel NET88..."
    CMD="autossh -M 20009 -f -L 9209:$DEST_IP:$DEST_PORT -p $SSH_PORT msservice@16.163.60.169 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  CMS)
    DEST_IP="127.0.0.1"
    DEST_PORT="27017"
    SSH_PORT="22000"
    echo "Đang thiết lập tunnel CMS..."
    CMD="autossh -M 20010 -f -L 27018:$DEST_IP:$DEST_PORT -p $SSH_PORT daluzz@18.166.175.126 -i ~/.ssh/Daluzz9 -N"
    echo "Lệnh đang chạy: $CMD"
    $CMD
    ;;
  *)
    echo "Không hỗ trợ tunnel này: $TUNNEL"
    exit 1
    ;;
esac
