# sample-nodejs
When unsafe-perm is set to true, the user/group ID switching is suppressed when a package script is run. If false, non-root users will not be able to install packages.

Default: false if running as root, true otherwise
Type: Boolean

npm install downloads dependencies defined in a package.json file and generates a node_modules folder with the installed modules.

package-lock.json is automatically generated for any operations where npm modifies either the node_modules tree, or package.json

.npmrc ->This file is a configuration file for NPM, it defines the settings on how NPM should behave when running commands.

always-auth
Default: false
Type: Boolean
Force npm to always require authentication when accessing the registry, even for GET requests.


'npm start' runs the node script that is listed under start in the package.json
