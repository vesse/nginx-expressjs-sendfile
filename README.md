## nginx-expressjs-sendfile

Example of using X-Accel-Redirect with nginx and Expressjs to serve protected static files efficiently.

### How to try

* Edit the paths in `nginx.conf`
* Symlink `nginx.conf` to `/etc/nginx/sites-available` (or wherever your nginx configuration is)
* Restart: `sudo service nginx restart`
* Install node modules and start the node server:
    * `npm install`
    * `npm start`
* Go to `http://localhost/` and login with credentials `user` / `pass`
* See static data server from the `protected`  folder
* Logout, and try to get e.g. the JavaScript file by going to `http://localhost/js/script.js` (the URL from which it's loaded in `protected/index.html`)
