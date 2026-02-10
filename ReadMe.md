PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker inspect web-vol1 --format='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

/web-vol1 - 172.17.0.2



PS C:\\Users\\gmeurie\_belgium\\Docker\_Cours\\TP02> docker inspect web-vol2 --format='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

/web-vol2 - 172.17.0.3

