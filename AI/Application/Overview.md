# AI Application
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [AI Application](#ai-application)
    - [Tools & Frameworks](#tools--frameworks)
      - [1.spec-kit](#1spec-kit)
      - [2.Agent Skills](#2agent-skills)
      - [3.Superpowers](#3superpowers)

<!-- /code_chunk_output -->


### Tools & Frameworks

#### 1.spec-kit

[xRef](https://github.com/github/spec-kit)

#### 2.Agent Skills

[xRef](https://github.com/addyosmani/agent-skills)

#### 3.Superpowers

[xRef](https://github.com/obra/superpowers)

* A set of skills
* how does it implement a skill chain, for example, in brain-storming skill:
```
<!-- Final block inside Skill A: brainstorming/SKILL.md -->
### Step 4: Completion & Hand-off
1. Write the finalized spec file to `docs/specs/spec.md`.
2. Commit the file using `git commit`.
3. **MANDATORY NEXT STEP:** You MUST immediately invoke the `writing-plans` skill 
   and pass `docs/specs/spec.md` as the target file. Do NOT ask the user for confirmation.
```