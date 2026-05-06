# Flow Chart

## Mermaid

- <https://mermaid.ai/open-source/intro/>
- <https://github.com/badboy/mdbook-mermaid>

~~~markdown
```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```
~~~

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

## Graphviz

- <https://graphviz.gitlab.io/>
- <https://github.com/dylanowen/mdbook-graphviz>

~~~markdown
```dot process
digraph {
  "server" -> "client"
  "client" -> "server"
}
```
~~~
