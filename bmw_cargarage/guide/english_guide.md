------------------------------------
ESX Garage System - Guide (EN)
------------------------------------

This script allows players to store and retrieve their vehicles from various garages. The garages are configurable, and players can park and unpark vehicles based on their stored data.

-----------------------
1. Installation
-----------------------

1.1. Copy all script files (config.lua, fxmanifest.lua, server/main.lua, client/main.lua) into your resources folder.

1.2. Add the resource to your `server.cfg`:
    ```
    ensure bmw_cargarage
    ```

1.3. Ensure that you have oxmysql installed and configured on your server, as this script uses a MySQL database to manage vehicle data.

-----------------------
2. Configuration
-----------------------

Configuration is done in the `configuration.lua` file. You can define multiple garages with different coordinates.

Each garage needs the following information:

    - `Pos`: The coordinates where the player can access the garage menu.
    - `SpawnPoint`: The coordinates where the vehicle will appear when unparked.
    - `DeletePoint`: The location where the player can return (park) the vehicle.

Example:
```lua
Config.Garages = {
    ['Garage1'] = {
        Pos = vector3(215.800, -810.057, 30.727),
        SpawnPoint = vector3(229.700, -800.114, 30.572),
        DeletePoint = vector3(215.124, -791.377, 30.646),
    },
    ['Garage2'] = {
        Pos = vector3(-334.685, 289.773, 84.705),
        SpawnPoint = vector3(-341.685, 285.773, 84.705),
        DeletePoint = vector3(-342.685, 283.773, 84.705),
    }
}
