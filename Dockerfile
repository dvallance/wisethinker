FROM bundler/app
CMD ["thin", "-R", "config.ru", "--environment", "production", "--threaded", "--no-epoll", "-p", "80", "start"]
