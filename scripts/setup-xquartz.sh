#!/bin/bash

# Script para iniciar XQuartz en macOS

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🚀 Iniciando XQuartz..."
    
    # Abrir XQuartz
    open -a XQuartz 2>/dev/null || {
        echo "❌ XQuartz no está instalado"
        echo "   Instálalo con: brew install --cask xquartz"
        exit 1
    }
    
    # Configurar para aceptar conexiones TCP
    defaults write org.xquartz.X11 nolisten_tcp -bool false
    
    # Esperar a que XQuartz inicie
    echo "⏳ Esperando a que XQuartz inicie..."
    sleep 2
    
    # Permitir conexiones desde localhost
    DISPLAY=:0 /opt/X11/bin/xhost + 2>/dev/null || {
        echo "⚠️  Esperando a que XQuartz esté completamente listo..."
        sleep 1
    }
    
    echo "✅ XQuartz configurado correctamente"
else
    echo "⚠️  Esta tarea es solo para macOS"
fi
