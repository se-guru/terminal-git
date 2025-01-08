docker build -t terminal-app .
docker run -d -p 7681:7681 -p 8448:8448 --name terminal-container terminal-app