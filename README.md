# Cómo montar un entorno de desarrollo para Java Swing

¡Hola developer 👋🏻! En este repo encontrarás todo lo que necesitas para levantar un entorno de desarrollo para Java Swing 🤸🏻 gracias a Dev Containers.


## Requisitos del host

Para poder ejecutar este proyecto necesitarás tener instalado lo siguiente en tu máquina:

- [Docker](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [Extensión de Dev Containers para Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 

X11 server (solo para Linux y MacOS):

- Linux: Asegúrate de tener instalado un servidor X11 (la mayoría de las distribuciones lo tienen por defecto).
- MacOS: Instala [XQuartz](https://www.xquartz.org/) puedes hacerlo de forma sencilla usando [Homebrew](https://brew.sh/):

```bash
brew install --cask xquartz
```

Una vez instalado, inicia XQuartz y ve a `Preferences > Security` y marca la opción `Allow connections from network clients`. Luego, reinicia XQuartz. Puedes hacerlo a través de la linea de comandos:

```bash
open -a XQuartz
defaults write org.xquartz.X11 nolisten_tcp -bool false
DISPLAY=:0 /opt/X11/bin/xhost +
```

Si quieres restringirlo después de usarlo, puedes ejecutar:

```bash
DISPLAY=:0 /opt/X11/bin/xhost -
```

Para comprobar que esta configuración funciona correctamente abre este repo dentro de un contenedor y ejecuta:

```bash
echo $DISPLAY
xeyes
```


## Windows

En el caso de Windows con WSL2/WSLg, no es necesario instalar un servidor X11 adicional, ya que WSLg ya incluye soporte para aplicaciones gráficas de Linux de forma nativa.

Por lo que lo único que necesitas es tener instalado Docker Desktop con WSL2 y la extensión de Dev Containers en Visual Studio Code.

Si arrancas el contenedor en Windows solamente lanzando este comando:

```bash
xeyes
```

Ya deberías de ver los ojos 👀 siguiendo el cursos del ratón.

## Probar el ejemplo de Java Swing

Para invocar este proyecto, siga estos pasos:

```bash
cd src
java -c HelloSwing.java
java HelloSwing
``` 