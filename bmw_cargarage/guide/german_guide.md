------------------------------------
ESX Garagensystem - Anleitung (DE)
------------------------------------

Dieses Skript ermöglicht das Speichern und Ausparken deiner Fahrzeuge in verschiedenen Garagen. Du kannst die Garage nach deinen Wünschen konfigurieren, Fahrzeuge ausparken und wieder einparken.

-----------------------
1. Installation
-----------------------

1.1. Kopiere alle Skriptdateien (config.lua, fxmanifest.lua, server/main.lua, client/main.lua) in deinen Ressourcenordner.

1.2. Füge die Ressource zu deiner `server.cfg` hinzu:
    ```
    ensure bmw_cargarage
    ```

1.3. Stelle sicher, dass du oxmysql auf deinem Server installiert und konfiguriert hast, da das Skript mit einer MySQL-Datenbank arbeitet.

-----------------------
2. Konfiguration
-----------------------

Die Konfiguration erfolgt in der Datei `configuration.lua`. Hier kannst du verschiedene Garagen definieren und deren Koordinaten festlegen.

Jede Garage benötigt folgende Informationen:

    - `Pos`: Die Koordinaten des Garagenmenüs, wo der Spieler interagiert.
    - `SpawnPoint`: Der Punkt, an dem das ausgeparkte Fahrzeug erscheint.
    - `DeletePoint`: Der Punkt, an dem der Spieler das Fahrzeug wieder einparken kann.

Beispiel:
```lua
Config.Garages = {
    ['Garage1'] = {
        Pos = vector3(215.800, -810.057, 30.727),
        SpawnPoint = vector3(229.700, -800.114, 30.572),
        DeletePoint = vector3(215.124, -791.377, 30.646),
    }
}
