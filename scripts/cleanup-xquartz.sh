#!/bin/bash

# Script para cerrar XQuartz en macOS

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🛑 Cerrando XQuartz..."
    
    # Verificar si XQuartz está ejecutándose (buscar por X11 o XQuartz)
    if pgrep -i "xquartz|X11" > /dev/null || ps aux | grep -i "[X]11" > /dev/null; then
        # Cerrar XQuartz de forma limpia
        osascript -e 'quit app "XQuartz"' 2>/dev/null || killall XQuartz 2>/dev/null
        echo "✅ XQuartz cerrado correctamente"
    else
        echo "ℹ️  XQuartz no está ejecutándose"
    fi
else
    echo "⚠️  Esta tarea es solo para macOS"
fi
