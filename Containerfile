FROM ghcr.io/projectbluefin/egg:latest

RUN bootc container lint || true
