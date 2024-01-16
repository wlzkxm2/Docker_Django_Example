# 생성할 이미지의 베이스가 될 이미지
FROM python:3.10

RUN mkdir /root/.ssh/

ADD ~/.ssh/id_rsa /root/.ssh/id_rsa

RUN chmod 600 /root/.ssh/id_rsa

RUN touch /root/.ssh/known_hosts

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# 명령어를 실행할 디렉토리
WORKDIR /home/ubuntu/

RUN apt-get update -y

# git repo clone
RUN git clone git@github.com:wlzkxm2/Docker_Django_Example.git
RUN rm /root/.ssh/id_rsa

WORKDIR /home/ubuntu/Docker_Django_Example/

# 라이브러리 설치
RUN pip install -r requirements.txt

# gunicorn 설치
RUN pip install gunicorn

RUN python3 manage.py collectstatic
RUN python3 manage.py makemigrations
RUN python3 manage.py migrate

# 해당 이미지로 컨테이너를 실행할때 어떤 명령어를 통해 수행할것인지
# 하나의 Dockerfile에서 한번만 수행가능
CMD ["/bin/bash","-c", "gunicorn Application.wsgi --bind 0.0.0.0:8000"]