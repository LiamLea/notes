# Chatgpt


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Chatgpt](#chatgpt)
    - [prompts](#prompts)
      - [1.修改提问的语法](#1修改提问的语法)

<!-- /code_chunk_output -->

### prompts

#### 1.修改提问的语法

```text
From this point forward, if all my input, including instructions, is grammatically incorrect or the expression isn't proper, please correct all my input including instructions and provide the corrected version of all my input after [Grammar]. You also need to follow my instructions in terms of the corresponding input after [GPT]. For example i input "South Korea’s military said it had identified what it believed were various North Korean weapons.  please analyses the grammar"
, you should give the right grammar of "South Korea’s military said it had identified what it believed were various North Korean weapons.  please analyses the grammar" in the [grammar] part and analyze the grammar of "South Korea’s military said it had identified what it believed were various North Korean weapons." in the [GPT] part.
```

* 优化
```text
From this point forward, please reponse in two parts [Grammar] and [GPT]. Correct the grammar of my all input including the instructions in [Grammar] part and follow my instructions in terms of the corresponding input in the [GPT] part.For example, when i input "South Korea’s military said it had identified what it believed were various North Korean weapons. please analyses the grammar"
, you should give the right grammar of "South Korea’s military said it had identified what it believed were various North Korean weapons. please analyses the grammar" in the [grammar] part and analyze the grammar of "South Korea’s military said it had identified what it believed were various North Korean weapons." in the [GPT] part. For another example, when i input "South Korea’s military said it had identified what it believed were various North Korean weapons. meaning"
, you should give the right grammar of "South Korea’s military said it had identified what it believed were various North Korean weapons. meaning" in the [grammar] part and analyze the meaning of "South Korea’s military said it had identified what it believed were various North Korean weapons." in the [GPT] part.
```

* 测试
```shell
South Korea’s military said it had identified what it believed were various North Korean weapons. please analyses the grammar

South Korea’s military said it had identified what it believed were various North Korean weapons. meaing

Emmanuel Macron Calls for Release of Franco-Israeli Hostage Mia Schem. what does " Franco-Israeli" here

how to change stdout of a running process in linux
```


```text
From this point forward, you are always going to generate two responses in two paragraphs, one right grammar version and one with the result. This data pairing will be used for juxtaposition. You will use the tags Grammar and GPT before your responses. For example: [Grammar]: This is the version of right grammar. [GPT]: This is the result. Correct the grammar of whatever i input and instructions i input, and give the right version in Grammar part.Then follow my instructions in terms of the corresponding input and give the result in the GPT part.For example: when i input "It's a sentence. please analyses the grammar"
, you must give the right grammar of "It's a sentence. please analyses the grammar" in the Grammar part and analyze the grammar of "It's a sentence." in the GPT part.
```