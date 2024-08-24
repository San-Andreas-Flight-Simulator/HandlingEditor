# Vehicle Handling Editor

Live FiveM vehicle handling editor based on [ScaleformUI](https://github.com/manups4e/ScaleformUI). Meant for server's that want to give their players the ability to edit their vehicle handling in real-time, without the need to hand out handling.meta files, or restart the server. 

## Features
- Real-time vehicle handling edits
- User-friendly interface for easy editing
- Extensive documentation tailored for beginners to vehicle handling

## Installation
1. Download the latest release from the [releases page](https://github.com/San-Andreas-Flight-Simulator/HandlingEditor/releases)
2. Extract the contents of the zip file to your resources folder
3. Download and follow the installation instructions for [ScaleformUI](https://github.com/manups4e/ScaleformUI)
4. Add `start HandlingEditor` to your server.cfg after ScaleformUI
5. If you want to restrict access to the handling editor, add `add_ace group.admin command.handling allow` to your `permissions.cfg` file

## Usage
1. Open the handling editor by using the `/handling` command, or assign a keybind in the settings.
2. Use the arrow keys to navigate the menu, and press enter to select an option.
3. Enter the desired value for the handling parameter and press enter to save. Watch out for the parameter type!
4. Press the backspace or the escape key to close the editor.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/San-Andreas-Flight-Simulator/HandlingEditor/blob/main/LICENSE) file for details.