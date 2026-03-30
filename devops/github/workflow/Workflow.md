# Workflow


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Workflow](#workflow)
    - [Quick Start](#quick-start)
      - [1.basic usage](#1basic-usage)
        - [(1) events block](#1-events-block)
        - [(2) jobs block](#2-jobs-block)
    - [Jobs](#jobs)
      - [1.steps (actions)](#1steps-actions)
        - [(1) default variables](#1-default-variables)
        - [(2) common actions](#2-common-actions)
      - [2.basic features](#2basic-features)
        - [(1) secrets](#1-secrets)
        - [(2) environment](#2-environment)
      - [3.outputs](#3outputs)
        - [(1) job outputs](#1-job-outputs)
        - [(2) step outputs](#2-step-outputs)
      - [4.conditions](#4conditions)
      - [5.dependency](#5dependency)
      - [6.context](#6context)

<!-- /code_chunk_output -->

### Quick Start

#### 1.basic usage

* `.github/workflows/xx.yaml`

```yaml
name: <workflow name>
on: <events_block>        # specify which event will trigger this workflow
jobs: <jobs_block>        # define jobs (jobs can be executed parallelly)
```

##### (1) events block

[more events](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows)

```yaml
on:                     # set which condition will trigger the workflow

  push:
    branches:
    - master            # pushing something to master will trigger

  workflow_dispatch:    # To enable a workflow to be triggered manually
    inputs: 
      PR_number:
        description: 'pull request number'
        required: true

  issues:
    types:
    - opened            # opening an issue will trigger
```

##### (2) jobs block

```yaml
jobs:
  <job_name>:
    runs-on: ubuntu-latest
    steps: []
```

***

### Jobs

#### 1.steps (actions)

* run shell
```yaml
steps:
- name: <step_name>
  id: <step_id>
  run: |
      echo "aaaaa"
      echo "bbbbba"
      echo "ccccccc"

- name: <step_name>
  id: <step_id>
  run: sudo ././github/workflows/test.sh
```

##### (1) default variables

[more variables](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#default-environment-variables)

##### (2) common actions
[more actions](https://github.com/actions)

* checkout
```yaml
# This action checks-out your repository under $GITHUB_WORKSPACE, so your workflow can access it
- uses: actions/checkout@v4
```

* install python
```yaml
- uses: actions/setup-python@v2
```

* debug (can ssh to the runner to debug)
```yaml
- name: Setup tmate session
  if: ${{ failure() }}
  uses: mxschmitt/action-tmate@v3
```

#### 2.basic features

##### (1) secrets
* set secrets which can be used by `${secrets.<secret_name>}`

##### (2) environment
* set the environment for a job
  * can set secrets which can be used in the env
  * can set reviewers for the job to run

#### 3.outputs

##### (1) job outputs
```yaml
outputs:
  random-number:
    description: "Random number"
    value: ${{ steps.random-number-generator.outputs.random-id }}
runs:
  using: "composite"
  steps:
    - id: random-number-generator
      run: echo "random-id=$(echo $RANDOM)" >> $GITHUB_OUTPUT
      shell: bash
```

##### (2) step outputs
```yaml
- name: Set color
  id: color-selector
  run: echo "SELECTED_COLOR=green" >> "$GITHUB_OUTPUT"
- name: Get color
  env:
    SELECTED_COLOR: ${{ steps.color-selector.outputs.SELECTED_COLOR }}
    STD_OUTPUT: ${{ steps.color-selector.outputs.stdout }}
  run: echo "The selected color is $SELECTED_COLOR"

```

#### 4.conditions
```yaml
jobs:
  production-deploy:
    if: github.repository == 'octo-org/octo-repo-prod'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '14'
      - run: npm install -g bats
```

#### 5.dependency
```yaml
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]
```

#### 6.context

[ref](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/accessing-contextual-information-about-workflow-runs)

* dump github context

```yaml
- name: "dump githup context"
  run: echo '${{ toJSON(github.event) }}' | jq
  shell: bash
```



