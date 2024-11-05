# Write Actions


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Write Actions](#write-actions)
    - [Overview](#overview)
      - [1.demo](#1demo)
        - [(1) directory architecture](#1-directory-architecture)
        - [(1) define interface](#1-define-interface)
        - [(2) write js code](#2-write-js-code)
        - [(3) build](#3-build)

<!-- /code_chunk_output -->


### Overview

#### 1.demo

[ref](https://github.com/actions/javascript-action)

##### (1) directory architecture

* main achitecture

```
./javascript-action/
├── action.yml
├── dist
│   └── index.js
├── src
│   └── index.js
├── package-lock.json
└── package.json
```

* package.json
```json
{
  "name": "javascript-action",

  "scripts": {
    // build code and generate dist/index.js
    "package": "npx ncc build src/index.js -o dist --source-map --license licenses.txt",

    //...
  }

  //...
}
```

##### (1) define interface

* `action.yml`

```yaml
name: 'The name of your action here'
description: 'Provide a description here'
author: 'Your name or organization here'

# Define your inputs here.
inputs:
  milliseconds:
    description: 'Your input description here'
    required: true
    default: '1000'

# Define your outputs here.
outputs:
  time:
    description: 'Your output description here'

runs:
  using: node20             # set runtime
  main: dist/index.js       # set entrypoint
```

##### (2) write js code

* `src/index.js`

```js
// core modules (read inputs from interface file and etc.)
const core = require('@actions/core')

// implement interface
const { wait } = require('./wait')

/**
 * The main function for the action.
 * @returns {Promise<void>} Resolves when the action is complete.
 */
async function run() {
  try {
    // read inputs
    const ms = core.getInput('milliseconds', { required: true })

    // Debug logs are only output if the `ACTIONS_STEP_DEBUG` secret is true
    core.debug(`Waiting ${ms} milliseconds ...`)

    // Log the current timestamp, wait, then log the new timestamp
    core.debug(new Date().toTimeString())
    await wait(parseInt(ms, 10))
    core.debug(new Date().toTimeString())

    // Set outputs for other workflow steps to use
    core.setOutput('time', new Date().toTimeString())

  } catch (error) {
    // Fail the workflow run if an error occurs
    core.setFailed(error.message)
  }
}

run()
```

##### (3) build
```shell
npm package
```