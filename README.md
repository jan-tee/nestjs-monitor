![Build npm package](https://github.com/jan-tee/nestjs-monitor/workflows/Build%20npm%20package/badge.svg)

# @jan-tee/nestjs-monitor

This is a simple monitoring package for NestJS projects.

It allows you to easily

* report on CPU and heap usage
* register your own metrics to be recorded and reported
* register loggers to be recorded and reported

The default interval for logging is 10 seconds. You can set a different interval (in ms) by configuring the `MONITORING_INTERVAL` environment variable.