# hubot-memegen-link

[![Build Status](https://travis-ci.org/ClaudeBot/hubot-memegen-link.svg)](https://travis-ci.org/ClaudeBot/hubot-memegen-link)
[![devDependency Status](https://david-dm.org/ClaudeBot/hubot-memegen-link/dev-status.svg)](https://david-dm.org/ClaudeBot/hubot-memegen-link#info=devDependencies)

A Hubot script for creating memes from templates using [memegen.link](http://memegen.link/).

See [`src/hubot-memegen.coffee`](src/hubot-memegen.coffee) for full documentation.


## Installation via NPM

1. Install the __hubot-memegen-link__ module as a Hubot dependency by running:

    ```
    npm install --save hubot-memegen-link
    ```

2. Enable the module by adding the __hubot-memegen-link__ entry to your `external-scripts.json` file:

    ```json
    [
        "hubot-memegen-link"
    ]
    ```

3. Run your bot and see below for available config / commands


## Commands

Command | Listener ID | Description
--- | --- | ---
hubot meme create | `memegen.new` | Starts meme creation process
hubot meme cancel | `memegen.cancel` | Cancels the meme creation process


## Sample Interaction

```
user1>> hubot meme create
hubot>> user1: (1/3) Creating a meme. What template should I use (reply with the key)?
user1>> chosen
hubot>> user1: (2/3) What should the top text be?
user1>> Ayy
hubot>> user1: (3/3) What should the bottom text be?
user1>> lmao
hubot>> Visible: http://memegen.link/chosen/hello-world%21/ayy-lmao%21.jpg
hubot>> Masked: http://memegen.link/_Y2hvc2VuCWhlbGxvLXdvcmxkIS9heXktbG1hbyEJ.jpg
```
