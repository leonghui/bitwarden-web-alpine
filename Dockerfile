FROM alpine:3.7

WORKDIR /root

RUN apk update && \
	apk add --no-cache \
		git \
		nodejs-npm \
	; \
	git clone https://github.com/bitwarden/web.git bitwarden-web \
	; \
	cd /root/bitwarden-web \
	; \
	mv settings.json settings.json.bak \
	; \
	cp settings.Production.json settings.json \
	; \
	sed -i 's/"env": "Production"/"env": "Development"/' package.json \
	; \
	npm install && npm install --global gulp-cli \
	; \
	gulp dist:selfHosted && gulp build

EXPOSE 4001

WORKDIR /root/bitwarden-web

CMD echo "VAULT_URL = http://$(hostname -i):4001/" 2>&1 ; gulp serve
