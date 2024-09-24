#  基础镜像
FROM registry.cn-hangzhou.aliyuncs.com/lcy-dockerhub/python:3.9

# 设置工作目录为 /test_automation
WORKDIR /test_automation

# 复制 requirements.txt 并安装依赖
COPY requirements.txt .

# 升级 pip 并安装依赖
RUN pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple

RUN pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple --timeout=400

# 复制项目代码到工作目录
COPY . .

# 设置默认命令
CMD ["pytest", "tests/test_example.py"]
