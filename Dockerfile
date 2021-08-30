FROM node:13.12.0 as builder
ENV VERSION=1.10.1 
RUN mkdir /yapi
RUN curl https://codeload.github.com/YMFE/yapi/zip/refs/tags/v${VERSION} -o yapi.zip
RUN unzip yapi.zip && mv yapi-${VERSION} /yapi/vendors && \
  cd /yapi/vendors && \
  npm install --production --registry https://registry.npm.taobao.org


FROM node:13.12.0-alpine
LABEL author="BossLin"
COPY --from=builder /yapi/vendors /yapi/vendors
# 工作目录
WORKDIR /yapi/vendors
# 配置yapi的配置文件
COPY config.json /yapi/
# 复制执行脚本到容器的执行目录
COPY entrypoint.sh /usr/local/bin/

#make the start.sh executable 
RUN chmod 777 /usr/local/bin/entrypoint.sh 

# 向外暴露的端口
EXPOSE 3000

# 配置入口为bash shell
ENTRYPOINT ["entrypoint.sh"]